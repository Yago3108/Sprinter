import 'package:flutter/material.dart';
import 'pagina_perfil.dart';
import 'pagina_tela_inicial.dart';
import 'pagina_mapa.dart';


class PaginaCompras extends StatefulWidget {
   const PaginaCompras({super.key});

  @override
  PaginaComprasState createState() => PaginaComprasState();
}

class PaginaComprasState extends State<PaginaCompras> {
  void perfil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaPerfil()));
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
       home: Scaffold(
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