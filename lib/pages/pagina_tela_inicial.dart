import 'package:flutter/material.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  PaginaInicialState createState() => PaginaInicialState();
}

class PaginaInicialState extends State<PaginaInicial> {

  @override
  Widget build(BuildContext context) {
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
                    Text("a"),
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

