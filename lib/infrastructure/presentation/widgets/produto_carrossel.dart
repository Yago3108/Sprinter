import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_produto.dart';

class ProdutoCarrossel extends StatelessWidget {
  final String produtoId; // ID do documento no Firestore
  final double? height;
  final double? width;
  const ProdutoCarrossel({super.key, required this.produtoId,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('produtos')
          .doc(produtoId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("Produto não encontrado"));
        }

        var produto = snapshot.data!.data() as Map<String, dynamic>;

        // Decodifica a imagem Base64
        Uint8List? imagemBytes;
        try {
          imagemBytes = base64Decode(produto['imagemBase64']);
        } catch (_) {}

        return IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PaginaProduto(null, produtoId)),
            );
          },
          icon: Container(
            width: width,
            height: height,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 230, 230, 230),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(15),
                    child: imagemBytes != null
                        ? Image.memory(
                            imagemBytes,
                            height: (height!-80),
                            width: width,
                            fit: BoxFit.fill,
                          )
                        : const SizedBox(
                            height: 150,
                            child: Center(child: Icon(Icons.image, size: 50)),
                          ),
                  ),
                  SizedBox(height: 15),
                  Flexible(
                    child: Text(
                      produto['nome'],
                      style: TextStyle(
                        fontSize: (height!*0.09),
                        fontFamily: 'League Spartan',
                        color: const Color.fromARGB(255, 29, 64, 26),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
