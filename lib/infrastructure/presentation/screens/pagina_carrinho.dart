import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/widget_produto_carrinho.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil.dart';
import 'package:provider/provider.dart';

class PaginaCarrinho extends StatelessWidget {
  const PaginaCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
       final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user!.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null) {
      bytes = base64Decode(fotoBase64);
    }
    return Scaffold(
       appBar: AppBar(
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Pagina(key: null,)));
            },
            icon: Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: CircleAvatar(
                backgroundImage: bytes != null
                    ? MemoryImage(bytes)
                    : AssetImage("assets/images/perfil_basico.jpg"),
                radius: 25,
              ),
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaPerfil()),
                ),
              },
            ),
          ],
        ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            WidgetProdutoCarrinho(id:"Rg3UsIfL6mCWI1u6Ymhb")
          ],
        ),
      ),
    );
  }
}