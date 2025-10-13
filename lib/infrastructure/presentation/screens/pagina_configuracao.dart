import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaginaConfiguracao extends StatefulWidget {
  const PaginaConfiguracao({super.key});

  @override
  State<PaginaConfiguracao> createState() => _PaginaConfiguracaoState();
}

bool emailValido = true;

class _PaginaConfiguracaoState extends State<PaginaConfiguracao> {
  Future<void> validarEmail() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      setState(() {
        emailValido = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'E-mail de recuperação de senha enviado com sucesso!',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar e-mail de recuperação de senha: $e'),
          ),
        );
      }
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
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Pagina(key: null,)));
            },
            icon: Icon(Icons.arrow_back),
          ),
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
        body: Column(
          children: [
             Padding(padding: EdgeInsets.only(top: 10)),
              Image.asset("assets/images/Logo_Sprinter.png", height: 100),
              Padding(padding: EdgeInsets.only(top: 10)),
              Padding(
                padding: const EdgeInsets.only(right: 210),
                child: Text("Olá, ${userProvider.user!.nome}!",
                style: TextStyle(
                      fontSize: 36,
                      fontFamily: "League Spartan"
                    ),
                ),
              ),
               Padding(padding: EdgeInsets.only(top: 10)),
                  Padding(
                padding: const EdgeInsets.only(right: 230),
                child: Text("Configurações:",
                style: TextStyle(
                      fontSize: 20,
                      fontFamily: "League Spartan"
                    ),
                ),
              ),
                Padding(padding: EdgeInsets.only(top: 15)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                    color: Color.fromARGB(160, 108, 109, 108), 
                    spreadRadius: 2, 
                    blurRadius: 7, 
                    offset: Offset(0, 3), 
                     ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text("Alterar Credenciais",style: TextStyle(
                    fontSize: 20,
                    fontFamily: "League Spartan"
                  ),),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
                 Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                    color: Color.fromARGB(160, 108, 109, 108), 
                    spreadRadius: 2, 
                    blurRadius: 7, 
                    offset: Offset(0, 3), 
                     ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.chat_bubble),
                    title: Text("Suporte",style: TextStyle(
                    fontSize: 20,
                    fontFamily: "League Spartan"
                  ),),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                    color: Color.fromARGB(160, 108, 109, 108), 
                    spreadRadius: 2, 
                    blurRadius: 7, 
                    offset: Offset(0, 3), 
                     ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("Sobre",style: TextStyle(
                    fontSize: 20,
                    fontFamily: "League Spartan"
                  ),),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                    color: Color.fromARGB(160, 108, 109, 108), 
                    spreadRadius: 2, 
                    blurRadius: 7, 
                    offset: Offset(0, 3), 
                     ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.delete_outline_rounded,
                    color: Colors.red,
                    ),
                    title: Text("Excluir conta",style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontFamily: "League Spartan"
                  ),),
                  ),
                ),
              ),
                 Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                    color: Color.fromARGB(160, 108, 109, 108), 
                    spreadRadius: 2, 
                    blurRadius: 7, 
                    offset: Offset(0, 3), 
                     ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.logout_rounded,
                    color: Colors.red,
                    ),
                    title: Text("Sair",style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontFamily: "League Spartan"
                  ),),
                  ),
                ),
              ),
          ],
        ),
      );
}
}