import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/button_componente.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/login/estado_login.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/cadastro-usuario/pagina_cadastro.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_esqueceu_senha.dart';
import 'package:myapp/infrastructure/presentation/usuario/estado_usuario.dart';
import 'package:provider/provider.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  // controllers
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  void fazerLogin() async {
    final provider = context.read<LoginProvider>();

    final isValid = provider.validarCampos(controllerEmail.text, controllerSenha.text);
    if (!isValid) return;

    final usuario = await provider.fazerLogin(controllerEmail.text, controllerSenha.text);

    if (usuario != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Sucesso no Login"),
          content: Text("Welcome, ${usuario.nome}!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<UsuarioProvider>().registrarUsuario(usuario);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Pagina()));
              },
              child: const Text("Continuar"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Falha no Login"),
          content: const Text("Email ou Senha incorretos"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginProvider>();

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Image.asset(
                    "assets/images/Logo_Sprinter.png",
                    height: 75,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 30, left: 30),
                  child: TextFieldComponente(
                    controller: controllerEmail,
                    hint: "Email do Usuário",
                    label: "Email",
                    error: provider.erroEmail,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, right: 30, left: 30),
                  child: TextFieldComponente(
                    controller: controllerSenha,
                    hint: "Senha do Usuário",
                    label: "Senha",
                    error: provider.erroPassword,
                    isPassword: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:200),
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>PaginaEsqueceuSenha())), 
                    child: Text("Esqueceu senha?",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "League Spartan"
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 30, left: 30),
                  child: ButtonComponente(
                    text: "LOGIN", 
                    function: fazerLogin,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaCadastro())),
                  child: Text(
                    "Não tem uma conta? Cadastre-se",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Lao Muang Don',
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  "Continuar com:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Lao Muang Don',
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/google.png",
                        ),
                        radius: 30,
                      ),
                      onPressed: () async {},
                    ),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    IconButton(
                      icon: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/facebook.png",
                        ),
                        radius: 30,
                      ),
                      onPressed: () async {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
