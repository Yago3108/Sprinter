import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class WidgetProdutoCarrinho extends StatefulWidget {
  final String id; // <--- AGORA É O ID DA COMPRA (DOC DA SUBCOLEÇÃO)

  const WidgetProdutoCarrinho({super.key, required this.id});

  @override
  State<WidgetProdutoCarrinho> createState() => _WidgetProdutoCarrinhoState();
}

class _WidgetProdutoCarrinhoState extends State<WidgetProdutoCarrinho> {
  // Future que carrega os dados da compra (quantidade, carbocoinsGastos, produtoId)
  late Future<DocumentSnapshot<Map<String, dynamic>>> _compraFuture;

  @override
  void initState() {
    super.initState();
  
  }
  
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializa o Future da compra
    final userId = context.read<UserProvider>().user!.uid;
    _compraFuture = _carregarDadosCompra(userId, widget.id);
  }


  // 1. FUNÇÃO PARA CARREGAR DADOS DA COMPRA
  Future<DocumentSnapshot<Map<String, dynamic>>> _carregarDadosCompra(
    String userId,
    String compraId,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .collection('compras') 
        .doc(compraId)
        .get();
    debugPrint("Compra $compraId carregada para o usuário $userId.");
    return snapshot;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _carregarProduto(String produtoId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('produtos')
        .doc(produtoId)
        .get();
    debugPrint("Produto $produtoId carregado.");
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _compraFuture, 
      builder: (context, compraSnapshot) {
        if (compraSnapshot.hasError) {
          return const Center(child: Text("Erro ao carregar detalhes da compra."));
        }
        if (compraSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!compraSnapshot.hasData || !compraSnapshot.data!.exists) {
          return const Center(child: Text("Compra não encontrada."));
        }

        final Map<String, dynamic> dadosCompra = compraSnapshot.data!.data()!;
        final String produtoId = dadosCompra['produtoId'] ?? '';
        final int quantidade = (dadosCompra['quantidade'] ?? 0).toInt();
        final double carbocoinsGastos = (dadosCompra['carbocoins'] ?? 0.0);
        final data=dadosCompra["dataCompra"].toDate()?? "";
        final String dataFormatada = DateFormat('dd/MM/yyyy').format(data);
        if (produtoId.isEmpty) {
            return const Center(child: Text("ID do produto inválido na compra."));
        }
        
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _carregarProduto(produtoId), 
          builder: (context, produtoSnapshot) {
            if (produtoSnapshot.hasError) {
              return const Center(child: Text("Erro ao carregar produto da compra."));
            }
            if (produtoSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            }
            if (!produtoSnapshot.hasData || !produtoSnapshot.data!.exists) {
              return const Center(child: Text("Produto da compra não encontrado."));
            }

         
            final Map<String, dynamic> produto = produtoSnapshot.data!.data()!;
            Uint8List? imagemBytes;

            try {
              if (produto.containsKey('imagemBase64') && produto['imagemBase64'] != null) {
                imagemBytes = base64Decode(produto['imagemBase64']);
              }
            } catch (_) {
            
            }
            
            // --- Renderização Final ---
            return Padding(
              padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
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
                iconColor: const Color.fromARGB(255, 5, 106, 12),
                textColor: const Color.fromARGB(255, 5, 106, 12),
                backgroundColor: Colors.white,
                title: ListTile(
                  leading: ClipRRect(
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
                  title: Text(
                    produto['nome'] ?? 'Produto sem nome',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Text(
                    "x$quantidade", 
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quantidade comprada: $quantidade",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                        Text(
                          "CarboCoins gastos: ${carbocoinsGastos.toStringAsFixed(0)} cc",
                          style: const TextStyle(fontSize: 14),
                        ),
                         Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                        Text(
                          "Data da compra: ${dataFormatada} ",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Padding(padding: EdgeInsetsGeometry.only(top: 8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.check_circle,color: const Color.fromARGB(255, 37, 97, 39),)
                          ],
                        )

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}