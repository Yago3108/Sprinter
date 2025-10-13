import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_esqueceu_senha.dart';
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
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user!.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null) {
      bytes = base64Decode(fotoBase64);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fundo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: CircleAvatar(
                            backgroundImage: bytes != null
                                ? MemoryImage(bytes, scale: 75)
                                : AssetImage("assets/images/perfil_basico.jpg"),
                            radius: 75,
                            child: Container(
                              height: 375,
                              width: 375,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 29, 64, 26),
                                ),
                                borderRadius: BorderRadius.circular(75),
                              ),
                            ),
                          ),
                          onPressed: () => {userProvider.selecionarImagem()},
                        ),
                        Positioned(
                          bottom: -3,
                          child:Container(
                            height: 15,
                            width: 15,
                            color: Colors.white,
                          ) ),
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
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      userProvider.user?.nome ?? "",
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontSize: 40,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userProvider.user?.carboCoins.toString() ?? "",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 5),
                                ),
                                Text(
                                  "carboCoins",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userProvider.user?.distancia.toStringAsFixed(1) ?? "",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 5),
                                ),
                                Text(
                                  "Distância",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userProvider.user?.carbono.toStringAsFixed(0) ?? "",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 5),
                                ),
                                Text(
                                  "carbono",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),

                    // O problema está aqui: TabBarView dentro de um ListView precisa de altura.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Container(
                        // 1. Usamos Container para aplicar a decoração de fundo e borda arredondada
                   
                     
                        height: 500, 
                        child: DefaultTabController(
                          length: 2,
                          initialIndex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.max, 
                            children: [
                            
                              Container(
                                     decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white, // Fundo branco para a seção de abas
                                ) ,
                                child: TabBar(
                                  dividerColor: Color.fromARGB(0, 0, 0, 0),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 141, 175, 138),
                                        Color.fromARGB(255, 29, 64, 26),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Color.fromARGB(255, 29, 64, 26),
                                  indicatorColor: Color.fromARGB(255, 0, 128, 0),
                                  tabs: [
                                    Tab(text: 'Últimas Atividades'),
                                    Tab(text: 'Detalhes'),
                                  ],
                                ),
                              ),
                              
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    // Aba 1: Últimas Atividades
                                    Container(
                                      // Padding para o conteúdo da TabBarView, se necessário
                                    ),
                                    
                                
                                    Container(
                                      padding: EdgeInsets.all(20),
                                           decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white, // Fundo branco para a seção de abas
                        ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(padding: EdgeInsets.only(top: 10)),
                                          
                
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: Text(
                                                userProvider.user?.email ?? "",
                                                style: TextStyle(fontFamily: 'Lao Muang Don', fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 30)),
                                          
                                     
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: Text(
                                                userProvider.user?.nascimento ?? "",
                                                style: TextStyle(fontFamily: 'League Spartan', fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 30)),
                            
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${userProvider.user?.carbono} kg CO2",
                                                style: TextStyle(fontFamily: 'League Spartan', fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 30)),
                                          
                                          // Bloco Senha
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "...........",
                                                style: TextStyle(fontFamily: 'League Spartan', fontSize: 40),
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 5)),
                                          
                                          // Botão Alterar Senha
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PaginaEsqueceuSenha(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Alterar Senha",
                                              style: TextStyle(
                                                fontFamily: 'League Spartan',
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 10)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}