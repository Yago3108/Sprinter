import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/pagina_produto.dart';

class ProdutoCard extends StatelessWidget {
  final String produtoId; // ID do documento no Firestore

  const ProdutoCard({super.key, required this.produtoId});

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
          imagemBytes = base64Decode(produto['imagem']);
        } catch (_) {}

        return IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PaginaProduto(null, produtoId)),
            );
          },
          icon: Container(
            width: 175,
            height: 350,
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
                  imagemBytes != null
                      ? Image.memory(
                          imagemBytes,
                          height: 175,
                          width: 175,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(
                          height: 150,
                          child: Center(child: Icon(Icons.image, size: 50)),
                        ),
                  SizedBox(height: 10),
                  Text(
                    produto['nome'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'League Spartan',
                      color: Color.fromARGB(255, 29, 64, 26),
                    ),
                  ),
                  Padding(padding: EdgeInsetsGeometry.only(top: 5)),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        " ${produto['preco'].toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 35,
                          fontFamily: "Medula One",
                          color: Color.fromARGB(255, 29, 64, 26),
                        ),
                      ),
                      Text(
                        " Cc",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "League Spartan",
                          color: Color.fromARGB(255, 29, 64, 26),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
