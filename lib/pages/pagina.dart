import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina_amizades.dart';
import 'package:myapp/pages/pagina_compras.dart';
import 'package:myapp/pages/pagina_configuracao.dart';
import 'package:myapp/pages/pagina_cria_produto.dart';
import 'package:myapp/pages/pagina_login.dart';
import 'package:myapp/pages/pagina_mapa.dart';
import 'package:myapp/pages/pagina_perfil.dart';
import 'package:myapp/pages/pagina_rendimento.dart';
import 'package:myapp/pages/pagina_tela_inicial.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';

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
  Uint8List? bytes;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carregarFotoPerfil();
    });
  }

  carregarFotoPerfil() {
    try {
      final userProvider = context.watch<UserProvider>();
      final fotoBase64 = userProvider.getFotoPerfil();

      if (fotoBase64 != null && fotoBase64.isNotEmpty) {
        setState(() {
          bytes = base64Decode(fotoBase64['fotoPerfil']);
        });
      }
    } catch (e) {
      print("FALHA AO CARREGAR IMAGEM DE PERFIL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        iconTheme: IconThemeData(color: Colors.white),

        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: bytes != null
                  ? MemoryImage(bytes!)
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
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text("Configurações"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaConfiguracao()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text("Cadastrar Produtos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CriarProdutoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Fazer Logout"),
              onTap: () {
                UserProvider userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                    userProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaLogin()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
            icon: Icon(Icons.people_alt_outlined),
            label: "Amizades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Comprar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: "Mapa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Rendimento",
          ),
        ],
      ),
    );
  }
}
