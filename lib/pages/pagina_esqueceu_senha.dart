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

  String? erroEmail;

  final email = FirebaseAuth.instance.currentUser?.email;

  TextEditingController emailController = TextEditingController();

  Future<void> validarEmail() async {
    if (emailController.text.isEmpty) {
      setState(() {
        emailValido = false;
        erroEmail = "Email não pode estar vazio";
      });
    } else if (emailController.text != email) {
      setState(() {
        emailValido = false;
        erroEmail = "Email inválido";
      });
    } else {
      emailValido = true;
      erroEmail = null;
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = email ?? "";
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
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Image.asset("assets/images/Logo_Sprinter.png", height: 100),
            Padding(padding: EdgeInsets.only(top: 10)),
            Icon(Icons.lock_rounded, size: 100),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text("Recuperação de Senha", style: TextStyle(fontSize: 20)),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextField(
              decoration: InputDecoration(
                labelText: ("Digite seu e-mail"),
                errorText: erroEmail,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
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
            Padding(padding: EdgeInsets.only(top: 30)),
            GestureDetector(
              onTap: () {
                userProvider.esqueceuSenha();
              },
              child: const Text("Reenviar"),
            ),
          ],
        ),
      ),
    );
  }
}
