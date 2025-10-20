import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaEsqueceuSenha extends StatefulWidget {
  const PaginaEsqueceuSenha({Key? key}) : super(key: key);

  @override
  _PaginaEsqueceuSenhaState createState() => _PaginaEsqueceuSenhaState();
}

class _PaginaEsqueceuSenhaState extends State<PaginaEsqueceuSenha> {
  final TextEditingController _emailController = TextEditingController();

  String? _erroEmail;

  Future<void> validarEmail() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _erroEmail = "Email não pode estar vazio";
      });
    } else {
      _erroEmail = null;
      await context.read<UserProvider>().esqueceuSenha();
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
            const SizedBox(height: 30),
            Image.asset("assets/images/Logo_Sprinter.png", height: 100),
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Icon(Icons.lock, size: 26),
                  SizedBox(width: 10),
                  Text("Recuperação de Senha", style: TextStyle(fontSize: 26)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFieldComponente(
                controller: _emailController,
                hint: "Email do Usuário",
                label: "Email",
                error: _erroEmail,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () => validarEmail(), 
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60),
                  backgroundColor: Color.fromARGB(255, 5, 106, 12),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Receber Link de Recuperação", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(right: 270),
              child: GestureDetector(
                onTap: () => validarEmail(),
                child: const Text("Reenviar", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
