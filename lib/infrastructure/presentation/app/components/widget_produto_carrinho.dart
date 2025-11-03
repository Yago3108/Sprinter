import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WidgetProdutoCarrinho extends StatefulWidget {
  final String id;
  
  // A string 'id' deve ser o ID do documento do produto no Firestore
  const WidgetProdutoCarrinho({super.key, required this.id});

  @override
  State<WidgetProdutoCarrinho> createState() => _WidgetProdutoCarrinhoState();
}

class _WidgetProdutoCarrinhoState extends State<WidgetProdutoCarrinho> {
  // O Future que será passado para o FutureBuilder
  late Future<DocumentSnapshot<Map<String, dynamic>>> _produtoFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa o Future no initState
    _produtoFuture = _carregarProduto();
  }

  // Função assíncrona que retorna o Future
  Future<DocumentSnapshot<Map<String, dynamic>>> _carregarProduto() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('produtos')
        .doc(widget.id)
        .get();
    debugPrint("Produto ${widget.id} carregado.");
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _produtoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar produto."));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.exists) {
          final Map<String, dynamic> produto = snapshot.data!.data()!;
          Uint8List? imagemBytes;

          try {
            if (produto.containsKey('imagemBase64') && produto['imagemBase64'] != null) {
              imagemBytes = base64Decode(produto['imagemBase64']);
            }
          } catch (_) {
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10,right: 15,left: 15),
            child: ExpansionTile(
            collapsedBackgroundColor: Colors.white,
                      collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide.none, 
                    ),
                    shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide.none, 
                    ),
                    iconColor: Color.fromARGB(255, 5, 106,12 ),  
                    textColor:Color.fromARGB(255, 5, 106,12 ) ,
                    backgroundColor: Colors.white,
              title: ListTile(
                leading:   ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imagemBytes != null
                          ? Image.memory(
                              imagemBytes,
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            )
                          : const Icon(Icons.shopping_bag, size: 30),
                    ),
                    title:   Text(produto['nome'] ?? 'Produto sem nome', style: TextStyle(fontSize: 16)),
              ),
              children:[
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow:  [
                   BoxShadow(
                    color: Color.fromARGB(117, 15, 15, 15), 
                    spreadRadius: 2, 
                    blurRadius: 3, 
                    offset: Offset(0, 3), 
                  ),
                ],
                ),
                child: Row(
                  children: [
                    
                    Padding(padding: EdgeInsets.only(left: 10)),
                  
       
                  ],
                ),
              ),
              ]

              
            ),
          );
        }
        return const Center(child: Text("Produto não encontrado no banco de dados."));
      },
    );
  }
}