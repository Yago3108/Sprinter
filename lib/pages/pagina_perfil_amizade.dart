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
      if (fotoBase64 != null) {
        setState(() {
          bytes = base64Decode(fotoBase64);
        });
      }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          iconTheme: IconThemeData(color: Colors.white),

          centerTitle: true,
         
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
                          child:  CircleAvatar(
                                backgroundImage: bytes != null && amigo!.fotoPerfil.isNotEmpty
                                    ? MemoryImage(bytes!, scale: 75)
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
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  amizadeProvider.verificarAmigo(widget.uidAmigo)==false?
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
                  ):Text("Seu Amigo",
                  style:TextStyle(
                  fontFamily: "League Spartan",
                  fontSize: 30,
                  color: Color.fromARGB(255, 59, 80, 48)
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
