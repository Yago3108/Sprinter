import 'package:flutter/material.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaCompras()));
  }
  void mapa() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaMapa()));
  }
  void telaInicial() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaInicial()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        body: Center(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
