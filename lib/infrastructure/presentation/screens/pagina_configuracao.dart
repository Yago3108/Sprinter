import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_login.dart';
import 'package:myapp/infrastructure/presentation/widgets/textfield_componente.dart';
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

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerChat = TextEditingController();
  int senhaTestada = 0;
  int cont = 0;
  bool credWid = false;
  void testeSenha(BuildContext context) {
    TextEditingController controllersSenha = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 350,
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Digite sua senha'),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFieldComponente(
                  controller: controllersSenha,
                  prefixIcon: Icons.lock,
                  hint: "Digite sua senha",
                  isPassword: true,
                  label: "Senha",
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              TextButton(
                onPressed: () async {
                  final userProvider = context.read<UserProvider>();
                  bool funciona = await userProvider.redefinirCredenciais(
                    controllersSenha.text,
                  );

                  if (funciona == true) {
                    setState(() {
                      controllerNome.text = userProvider.user!.nome;
                      credWid = true;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: "League Spartan",
                    color: Color.fromARGB(255, 5, 106, 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Pagina(key: null)),
            );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Image.asset("assets/images/Logo_Sprinter.png", height: 100),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              spacing: 0,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "Olá, ${userProvider.user!.nome}!",
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: "League Spartan",
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "Configurações:",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "League Spartan",
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  if (senhaTestada == 0 && credWid == false) {
                    testeSenha(context);
                    senhaTestada++;
                  }
                  if (senhaTestada == 1) {
                    senhaTestada = 0;
                  }
                },
                child: ExpansionTile(
                  collapsedBackgroundColor: Colors.white,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide.none,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide.none,
                  ),
                  iconColor: Color.fromARGB(255, 5, 106, 12),
                  textColor: Color.fromARGB(255, 5, 106, 12),
                  backgroundColor: Colors.white,
                  title: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(
                      "Alterar credenciais",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "League Spartan",
                      ),
                    ),
                  ),
                  enabled: credWid,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 15)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFieldComponente(
                              controller: controllerNome,
                              prefixIcon: Icons.person,
                              hint: "Digite o novo nome",
                              isPassword: false,
                              label: "Nome",
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 15)),
                          TextButton(
                            onPressed: () {
                              userProvider.atualizarNome(controllerNome.text);
                            },
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "League Spartan",
                                color: Color.fromARGB(255, 5, 106, 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ExpansionTile(
                collapsedBackgroundColor: Colors.white,
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide.none,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide.none,
                ),
                iconColor: Color.fromARGB(255, 5, 106, 12),
                textColor: Color.fromARGB(255, 5, 106, 12),
                backgroundColor: Colors.white,
                title: ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text(
                    "Sobre",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "League Spartan",
                    ),
                  ),
                ),

                children: [
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Image.asset("assets/images/Sprinter_simples.png", height: 70),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      title: Text(
                        "Versão: 1.0.0",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "League Spartan",
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      title: Text(
                        "Contato:sprintersuporte@gmail.com",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "League Spartan",
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  //Pede a senha
                  TextEditingController senhaController =
                      TextEditingController();

                  final confirmar = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Excluir conta"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Digite sua senha para confirmar a exclusão da conta."
                            "Esta ação não pode ser desfeita.",
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: senhaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Senha",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Cancelar"),
                          onPressed: () => Navigator.pop(context, null),
                        ),
                        TextButton(
                          child: const Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pop(context, senhaController.text);
                          },
                        ),
                      ],
                    ),
                  );

                  //Usuário cancelou
                  if (confirmar == null || confirmar.isEmpty) return;

                  final senhaDigitada = confirmar;

                  final userProvider = context.read<UserProvider>();

                  try {
                    await userProvider.excluirConta(senhaDigitada);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Conta excluída com sucesso."),
                      ),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const PaginaLogin()),
                      (route) => false,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao excluir conta: $e")),
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const ListTile(
                    leading: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Excluir conta",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: "League Spartan",
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.logout_rounded, color: Colors.red),
                  title: Text(
                    "Sair",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: "League Spartan",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
