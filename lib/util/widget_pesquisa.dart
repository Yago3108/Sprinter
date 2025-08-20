import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina_produto.dart';

class WidgetPesquisa extends StatefulWidget {
  const WidgetPesquisa({super.key});

  @override
  WidgetPesquisaState createState() => WidgetPesquisaState();
}

class WidgetPesquisaState extends State<WidgetPesquisa> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hint: Text("Ingresso para ..."),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value.trim();
              });
            },
          ),
          Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('produtos')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      final produtos = snapshot.data!.docs.where((doc) {
        final nome = doc['nome'].toString().toLowerCase();
        return nome.contains(query.toLowerCase());
      }).take(3).toList();

      if (produtos.isEmpty) {
        return Center(child: Text("Nenhum produto encontrado"));
      }

      return ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return ListTile(
            title: Text(produto['nome']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaginaProduto(null,produto.id),
                  
                ),
              );
            },
          );
        },
      );
    },
  ),
),

        ],
      ),
      
    );
  }
}
