import 'package:flutter/material.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  PaginaInicialState createState() => PaginaInicialState();
}

class PaginaInicialState extends State<PaginaInicial> {
 
  @override
  void initState() { 
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
     final userProvider = context.watch<UserProvider>();
    final dados = userProvider.getDistanciaEPontos();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
     

        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                Image.asset("assets/images/Logo_Sprinter.png", height: 100),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(child: Column(
                  children: [
                    Text("${dados?['distancia']}km")
                    ],
                ),),
                Container(child: Column(
                  children: [
                    Text("${dados?['pontos']} CarboCoins")
                  ]
                ),),
              ],
            )
          ),
        )   // mostra a tela atual

      
      ),
    );
  }
}

