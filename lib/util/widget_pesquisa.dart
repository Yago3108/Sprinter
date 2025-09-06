import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina_produto.dart';

class WidgetPesquisa extends StatefulWidget {
  final void Function(String produtoId) onProdutoSelecionado;

  const WidgetPesquisa({
    super.key,
    required this.onProdutoSelecionado,
  });
  @override
  WidgetPesquisaState createState() => WidgetPesquisaState();
}

class WidgetPesquisaState extends State<WidgetPesquisa> {
    OverlayEntry? _overlayEntry;
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

          StreamBuilder<QuerySnapshot>(
            stream: (query.isEmpty)
                ? FirebaseFirestore.instance
                      .collection('produtos')
                      .limit(3) // mostra 3 primeiros sem filtro
                      .snapshots()
                : FirebaseFirestore.instance
                      .collection('produtos')
                      .where('nome', isGreaterThanOrEqualTo: query)
                      .where('nome', isLessThanOrEqualTo: query + '\uf8ff')
                      .limit(3)
                      .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final produtos = snapshot.data!.docs;

              if (produtos.isEmpty) {
                return const Center(child: Text("Nenhum produto encontrado"));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];
                  return ListTile(
                    title: Text(produto['nome']),
                    onTap: () {
                    widget.onProdutoSelecionado(produto.id);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
  
    void _removerPesquisa() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
