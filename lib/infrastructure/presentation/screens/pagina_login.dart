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
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  String? _erroEmail;
  String? _erroSenha;

  void verificarELogar() async {
    setState(() {
      if (_controllerEmail.text.isEmpty) {
        _erroEmail = "Email não pode estar vazio";
      } else if (!_controllerEmail.text.contains("@")) {
        _erroEmail = "Email precisa conter @";
      } else {
        _erroEmail = null;
      }

      if (_controllerSenha.text.isEmpty) {
        _erroSenha = "Senha não pode estar vazia";
      } else if (_controllerSenha.text.length < 8) {
        _erroSenha = "Senha precisa ter, pelo menos, 8 dígitos";
      } else {
        _erroSenha = null;
      }
    });

    if (_erroEmail == null && _erroSenha == null) {
      final userProvider = context.read<UserProvider>();

      try {
        final user = await userProvider.login(_controllerEmail.text, _controllerSenha.text);

        if (user != null) {
          // limpa os controllers
          _controllerEmail.clear();
          _controllerSenha.clear();

          // navega para a página inicial
          Navigator.push(context, MaterialPageRoute(builder: (context) => Pagina()));
        }
      } catch (e) {
        setState(() {
          _erroEmail = "Login inválido";
          _erroSenha = "Login inválido";
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 30, left: 30),
                  child: TextFieldComponente(
                    controller: _controllerEmail,
                    hint: "Email do Usuário",
                    label: "Email",
                    error: _erroEmail,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, right: 30, left: 30),
                  child: TextFieldComponente(
                    controller: _controllerSenha,
                    hint: "Senha do Usuário",
                    label: "Senha",
                    error: _erroSenha,
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
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: ButtonComponente(
                    text: "Login", 
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
