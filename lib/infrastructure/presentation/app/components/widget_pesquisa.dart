import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/produto_carrossel.dart';

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
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hint: Text("Ingresso para ..."),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color:Color.fromARGB(255, 5, 106, 12), width: 1.5),
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value.trim();
              });
            },
          ),
           Padding(padding: EdgeInsetsGeometry.only(top: 5)),
           query==""?
          Column(
            children: [
               Padding(padding: EdgeInsetsGeometry.only(top: 5)),
               Text(
                      "Principais produtos:",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'League Spartan',
                        color: const Color.fromARGB(255, 29, 64, 26),
                      ),
                    ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 1,
                  children: [
                      ProdutoCarrossel(produtoId: "Rg3UsIfL6mCWI1u6Ymhb", height: 150, width: 150),
                      ProdutoCarrossel(produtoId: "W7ypyI5wvzlvw1FjE4q4", height: 150, width: 150),
                      ProdutoCarrossel(produtoId: "f80gFP9HAIo5woMkUFFY", height: 150, width: 150),
                  ],
                ),
              ),
            ],
          ):SizedBox(),
          Padding(padding: EdgeInsetsGeometry.only(top: 8)),
            Text(
                      "Outros produtos:",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'League Spartan',
                        color: const Color.fromARGB(255, 29, 64, 26),
                      ),
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

}
