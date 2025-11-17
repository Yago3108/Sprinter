import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class WidgetCarrinho extends StatefulWidget {
  final String produtoId;
  final int quantidade;
  final String userId;
  final int preco;
  final String nome;
  final String? imagemUrl;

  const WidgetCarrinho({
    Key? key,
    required this.produtoId,
    required this.quantidade,
    required this.userId,
    required this.preco,
    required this.nome,
    this.imagemUrl,
  }) : super(key: key);

  @override
  State<WidgetCarrinho> createState() => _WidgetCarrinhoState();
}

class _WidgetCarrinhoState extends State<WidgetCarrinho> {
  late int quantidade;
  late String nome;
  late int preco;
  late String userId;
  late String produtoId;
  late String? imagemUrl;

  @override
  void initState() {
    super.initState();
    quantidade = widget.quantidade;
    nome = widget.nome;
    preco = widget.preco;
    userId = widget.userId;
    produtoId = widget.produtoId;
    imagemUrl = widget.imagemUrl;
  }

  void _realizarCompra() {
    print("Compra realizada: $quantidade x $nome por \${preco * quantidade}");
    // Lógica para realizar a compra
  }

  void _mostrarMensagemSucesso() {
    final snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 5, 106, 12),
      content: Text(
        "Compra realizada: $nome",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 2),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _processarCompra() {
    _realizarCompra();
    _mostrarMensagemSucesso();
  }

  @override
  Widget build(BuildContext context) {
     Uint8List? bytes;
    if (imagemUrl != null && imagemUrl!.isNotEmpty) {
      try {
        bytes = base64Decode(imagemUrl!);
      } catch (_) { }
    }

    return Container(
      
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagem do produto
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: imagemUrl != null
                  ?  Image.memory(
                      bytes!,
                      height: 250,
                      width: 350,
                      fit: BoxFit.cover, 
                    )
                  : const Center(
                      child: Icon(
                        Icons.cake,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          
          // Informações do produto
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome do produto
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                   Text(
                  "${quantidade}x",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Preço
                Text(
                  (preco*quantidade).toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Botão Comprar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    _processarCompra();
                    Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Comprar",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}