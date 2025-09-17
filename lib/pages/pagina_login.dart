import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina.dart';
import 'package:myapp/pages/pagina_cadastro.dart';
import 'package:myapp/pages/pagina_esqueceu_senha.dart';
import 'package:myapp/pages/pagina_tela_inicial.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  //Controllers de TextField
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  //Variáveis de erro
  String? erroEmail;
  String? erroSenha;

  //Variáveis de controle
  bool emailValido = false;
  bool senhaValida = false;
  bool _obscureText = true;

  //Função para verificar os campos de texto e logar no sistema
  void verificarELogar() async {
    setState(() {
      //Verificação de Email
      if (controllerEmail.text.isEmpty) {
        emailValido = false;
        erroEmail = "Email não pode estar vazio";
      } else if (!controllerEmail.text.contains("@")) {
        emailValido = false;
        erroEmail = "Email precisa conter @";
      } else {
        emailValido = true;
        erroEmail = null;
      }
      
      //Verificação de Senha
      if (controllerSenha.text.isEmpty) {
        senhaValida = false;
        erroSenha = "Senha não pode estar vazia";
      } else if (controllerSenha.text.length < 8) {
        senhaValida = false;
        erroSenha = "Senha precisa ter, pelo menos, 8 dígitos";
      } else {
        senhaValida = true;
        erroSenha = null;
      }
    });

    //Se for válido, tenta logar no sistema
    if (emailValido && senhaValida) {
      try {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        var uid = await userProvider.login(controllerEmail.text, controllerSenha.text);

        if (uid != null) {
          controllerEmail.clear();
          controllerSenha.clear();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Pagina())); //Redireciona para tela inicial
        }
      } catch (e) { //Se der erro
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
                Container( //Logo
                  padding: EdgeInsets.only(top: 40),
                  child: Image.asset(
                    "assets/images/Logo_Sprinter.png",
                    height: 75,
                  ),
                ), //textfields
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: Column(
                    children: [
                      TextField( //TextField de Email
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          labelText: ("E-mail / nome de usuário"),
                          errorText: erroEmail,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Lao Muang Don',
                          ),
                          hintText: "Insira o Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 30)),

                      TextField( //TextField de Senha
                        controller: controllerSenha,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: ("Senha"),
                          errorText: erroSenha,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Lao Muang Don',
                          ),
                          hintText: "Insira a senha",
                          counter: TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaEsqueceuSenha())),
                            child: Container(
                              height: 20,
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Esqueceu a senha?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Lao Muang Don',
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 20)),

                      TextButton( //Botão de Login
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(1000, 5, 106, 12),
                        ),
                        onPressed: verificarELogar,
                        child: Container(
                          height: 50,
                          width: 319,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Lao Muang Don',
                            ),
                          ),
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

                      Padding(padding: EdgeInsets.only(top: 20)),
                      
                      const Text(
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
                          IconButton( //Logo do Google
                            icon: CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/google.png",
                              ),
                              radius: 30,
                            ),
                            onPressed: () {},
                          ),

                          Padding(padding: EdgeInsets.only(right: 10)),

                          IconButton( //Logo do Facebook
                            icon: CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/facebook.png",
                              ),
                              radius: 30,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
