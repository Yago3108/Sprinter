import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/pages/pagina.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';
import 'pagina_tela_inicial.dart';
import 'pagina_compras.dart';
import 'pagina_mapa.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  PaginaPerfilState createState() => PaginaPerfilState();
}

class PaginaPerfilState extends State<PaginaPerfil> {
  void compras() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaCompras()),
    );
  }

  void mapa() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaMapa()),
    );
  }

  void telaInicial() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaInicial()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.getFotoPerfil();
    Uint8List? bytes;
    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
      bytes = base64Decode(fotoBase64['fotoPerfil']);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          iconTheme: IconThemeData(color: Colors.white),

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

        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset("assets/images/Sprinter_simples.png"),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.black),
                title: Text("Pagina Inicial"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Pagina()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Fazer Logout"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  Image(image: AssetImage("assets/images/Logo_Sprinter.png")),
                  Padding(padding: EdgeInsets.only(top: 15)),

                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 163, 219, 99),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: CircleAvatar(
                            backgroundImage: bytes != null
                                ? MemoryImage(bytes, scale: 50)
                                : AssetImage("assets/images/perfil_basico.jpg"),
                            radius: 50,
                          ),
                          onPressed: () => {userProvider.selecionarImagem()},
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),

                        Text(
                          "NOME:",
                          style: TextStyle(
                            fontFamily: 'Lao Muang Don',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text(
                          userProvider.user?.nome ?? "",
                          style: TextStyle(
                            fontFamily: 'Lao Muang Don',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          width: 300,
                          height: 30,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userProvider.user?.email ?? "",
                                style: TextStyle(
                                  fontFamily: 'Lao Muang Don',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(Icons.email_outlined),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          width: 300,
                          height: 30,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userProvider.user?.nascimento ?? "",
                                style: TextStyle(
                                  fontFamily: 'Lao Muang Don',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(Icons.date_range),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          width: 300,
                          height: 30,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "***.***.***-**",
                                style: TextStyle(
                                  fontFamily: 'Lao Muang Don',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "CarboCoins:",
                          style: TextStyle(
                            fontFamily: 'Lao Muang Don',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${userProvider.user?.carboCoins} Cc",
                          style: TextStyle(
                            fontFamily: 'Lao Muang Don',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
