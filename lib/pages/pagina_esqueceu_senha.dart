import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina.dart';
import 'package:myapp/pages/pagina_perfil.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaEsqueceuSenha extends StatefulWidget {
  PaginaEsqueceuSenha({Key? key}) : super(key: key);

  @override
  _PaginaEsqueceuSenhaState createState() => _PaginaEsqueceuSenhaState();
}

class _PaginaEsqueceuSenhaState extends State<PaginaEsqueceuSenha> {
  bool emailValido = true;

  Future<void> validarEmail() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      setState(() {
        emailValido = true;
      });
    } else {
      setState(() {
        emailValido = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user?.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
      bytes = base64Decode(fotoBase64);
    }

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage:
                  bytes != null
                      ? MemoryImage(bytes)
                      : AssetImage("assets/images/perfil_basico.jpg"),
              radius: 25,
            ),
            onPressed:
                () => {
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
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Image.asset("assets/images/Logo_Sprinter.png", height: 100),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("Recuperação de Senha", style: TextStyle(fontSize: 20)),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextField(
              decoration: InputDecoration(
                labelText: ("Digite seu e-mail"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide(
                    color: emailValido ? Colors.black : Colors.red,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide(
                    color: emailValido ? Colors.black : Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextButton(
              onPressed: () {
                validarEmail();
              },
              child: const Text("Receber Link de Recuperação"),
            ),
          ],
        ),
      ),
    );
  }
}
