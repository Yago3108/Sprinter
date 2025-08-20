import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:myapp/util/widget_pesquisa.dart';
import 'package:provider/provider.dart';
import 'pagina_perfil.dart';
import 'pagina_tela_inicial.dart';
import 'pagina_mapa.dart';

class PaginaCompras extends StatefulWidget {
  const PaginaCompras({super.key});

  @override
  PaginaComprasState createState() => PaginaComprasState();
}

class PaginaComprasState extends State<PaginaCompras> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user?.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
      bytes = base64Decode(fotoBase64);
    }

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage:
                  bytes != null
                      ? MemoryImage(bytes)
                      : AssetImage("assets/images/perfil_basico.jpg"),
              radius: 25,
            ),
            onPressed:
                () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaPerfil()),
                  ),
                },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            WidgetPesquisa(),
            Padding(padding: EdgeInsets.only(top: 10)),
            const Text("Destaque:"),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset("assets/images/perfil_basico.jpg"),
                  ),
                  Text("Ingresso para ..."),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            const Text("mais vendidos"),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              height: 5,
              width: 50,
              color: Color.fromARGB(255, 5, 106, 12),
            ),
            
          ],
        ),
      ),
    );
  }
}
