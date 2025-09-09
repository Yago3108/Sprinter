import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/pages/pagina.dart';
import 'package:myapp/pages/pagina_perfil.dart';
import 'package:myapp/util/amigo.dart';
import 'package:myapp/util/amizade_provider.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:myapp/util/usuario.dart';
import 'package:provider/provider.dart';
import 'pagina_tela_inicial.dart';
import 'pagina_compras.dart';
import 'pagina_mapa.dart';

class PaginaPerfilAmizade extends StatefulWidget {
  final String uidAmigo;

  PaginaPerfilAmizade(param0, {super.key, required this.uidAmigo}) {
    final String uidAmigo;
    Key? key;
  }

  @override
  PaginaPerfilAmizadeState createState() => PaginaPerfilAmizadeState();
}

class PaginaPerfilAmizadeState extends State<PaginaPerfilAmizade> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final AmizadeProvider amizadeProvider = context.watch<AmizadeProvider>();
    Future<Usuario?> amigo1 = userProvider.getUsuarioByUid(widget.uidAmigo);
    Usuario? amigo = userProvider.usuarioPesquisado;
    amigo1.then((value) => amigo = value);
    if (amigo == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Carregando...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    amigo1.then((value) => amigo = value);
    final fotoBase64 = amigo?.fotoPerfil;
    Uint8List? bytes;

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
                  Padding(padding: EdgeInsets.only(top: 70)),

                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 127, 176, 100),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 60)),
                            Text(
                              amigo?.nome ?? "",
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 40,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Container(
                              width: 300,
                              height: 50,

                              decoration: BoxDecoration(
                                border: BoxBorder.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    amigo?.email ?? "",
                                    style: TextStyle(
                                      fontFamily: 'Lao Muang Don',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                border: BoxBorder.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    amigo?.nascimento ?? "",
                                    style: TextStyle(
                                      fontFamily: 'League Spartan',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Container(
                              width: 300,
                              height: 50,

                              decoration: BoxDecoration(
                                border: BoxBorder.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${amigo?.carbono} kg CO2",
                                    style: TextStyle(
                                      fontFamily: 'League Spartan',

                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Text(
                              "CarboCoins:",
                              style: TextStyle(
                                fontFamily: 'League Spartan',

                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "${amigo?.carboCoins.toStringAsFixed(0)} Cc",
                              style: TextStyle(
                                fontFamily: 'League Spartan',

                                fontSize: 40,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -75,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              icon: CircleAvatar(
                                backgroundImage: bytes != null
                                    ? MemoryImage(bytes, scale: 75)
                                    : AssetImage(
                                        "assets/images/perfil_basico.jpg",
                                      ),
                                radius: 75,
                                child: Container(
                                  height: 375,
                                  width: 375,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      color: Color.fromARGB(255, 29, 64, 26),
                                    ),

                                    borderRadius: BorderRadius.circular(75),
                                  ),
                                ),
                              ),
                              onPressed: () => {
                                userProvider.selecionarImagem(),
                              },
                            ),

                            Positioned(
                              bottom: -10,
                              child: Icon(
                                Icons.add_circle,
                                size: 30,
                                color: Color.fromARGB(255, 29, 64, 26),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  IconButton(
                    onPressed: () {
                      amizadeProvider.enviarPedidoAmizade(
                        userProvider.user!.nome,
                        userProvider.user!.uid,
                        widget.uidAmigo,
                      );
                      Navigator.pop(context);
                    },
                    icon: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 29, 64, 26),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
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
