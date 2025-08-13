import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina_amizades.dart';
import 'package:myapp/pages/pagina_compras.dart';
import 'package:myapp/pages/pagina_mapa.dart';
import 'package:myapp/pages/pagina_rendimento.dart';
import 'package:myapp/pages/pagina_tela_inicial.dart';

class Pagina extends StatefulWidget {
   const Pagina({super.key});

  @override
  State<Pagina> createState() => _PaginaState();
}

class _PaginaState extends State<Pagina> {
  int _paginaAtual = 2;

  final List<Widget> _paginas = [
    PaginaAmizades(),
    PaginaCompras(),
    PaginaInicial(),
    PaginaMapa(),
    PaginaRendimento(),
  ];

  @override
  Widget build(BuildContext context) {

        return Scaffold(
             appBar: AppBar(
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          iconTheme: IconThemeData(color: Colors.white),
          
          centerTitle: true,
          actions: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/perfil_basico.jpg"),
              radius: 25,
            ),
          ],
        ),

        drawer: Drawer(
          
          child: ListView(
            children: [
              DrawerHeader(child: Image.asset("assets/images/Sprinter_simples.png")),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Fazer Logout"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

            ],
          )
        ),
        backgroundColor: Color.fromARGB(255, 240, 240, 240), // Cor de fundo clara
      body: _paginas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        iconSize: 30,
        selectedItemColor: Color.fromARGB(255, 5, 106, 12),
        unselectedItemColor: Color.fromARGB(255, 5, 106, 12),
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Lao Muang Don',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Lao Muang Don',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: "Amizades"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Comprar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Início"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined), label: "Mapa"),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: "Rendimento"),
        ],
      ),
    );

  }
}