import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/button_componente.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_cadastro.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_esqueceu_senha.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
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

  // variáveis de erro
  String? erroEmail;
  String? erroSenha;

  void verificarELogar() async {
    setState(() {
      if (controllerEmail.text.isEmpty) {
        erroEmail = "Email não pode estar vazio";
      } else if (!controllerEmail.text.contains("@")) {
        erroEmail = "Email precisa conter @";
      } else {
        erroEmail = null;
      }

      if (controllerSenha.text.isEmpty) {
        erroSenha = "Senha não pode estar vazia";
      } else if (controllerSenha.text.length < 8) {
        erroSenha = "Senha precisa ter, pelo menos, 8 dígitos";
      } else {
        erroSenha = null;
      }
    });

    if (erroEmail == null && erroSenha == null) {
      try {
        UserProvider userProvider = Provider.of<UserProvider>(
          context,
          listen: false,
        );

        var uid = await userProvider.login(
          controllerEmail.text,
          controllerSenha.text,
        );

        if (uid != null) {
          // limpa os controllers
          controllerEmail.clear();
          controllerSenha.clear();

          // navega para a página inicial
          Navigator.push(context, MaterialPageRoute(builder: (context) => Pagina()));
        }
      } catch (e) {
        setState(() {
          erroEmail = "Login inválido";
          erroSenha = "Login inválido";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ), //textfields
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 30, left: 30),
                  child: TextFieldComponente(
                    controller: controllerEmail,
                    hint: "Email do Usuário",
                    label: "Email",
                    error: erroEmail,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, right: 30, left: 30),
                  child: TextFieldComponente(
                    controller: controllerSenha,
                    hint: "Senha do Usuário",
                    label: "Senha",
                    error: erroSenha,
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
                    function: verificarELogar,
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
