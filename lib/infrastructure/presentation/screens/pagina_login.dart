import 'package:flutter/material.dart';
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
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  String? erroEmail;
  String? erroSenha;

  bool emailValido = false;
  bool senhaValida = false;
  bool _obscureText = true;

  void cadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaCadastro()),
    );
  }

  void esqueceuSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaEsqueceuSenha()),
    );
  }

  void verificarELogar() async {
    setState(() {
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

    if (emailValido && senhaValida) {
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
          controllerEmail.clear();
          controllerSenha.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Pagina()),
          );
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
                SizedBox(height: 20),
                //imagem
                Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Image.asset(
                    "assets/images/Logo_Sprinter.png",
                    height: 75,
                  ),
                ), //textfields
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    top: 20,
                    left: 30,
                    right: 30,
                  ),
                  child: Column(
                    children: [
                      //Nome
                      TextField(
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          labelText: ("E-mail"),
                          errorText: erroEmail,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Lao Muang Don',
                          ),
                          hintText: "Insira Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsetsGeometry.only(top: 30)),
                      TextField(
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
                            onPressed: esqueceuSenha,
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

                      TextButton(
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
                      SizedBox(height: 5),

                      TextButton(
                        onPressed: cadastro,
                        child: Text(
                          "Não tem uma conta? Cadastre-se",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Lao Muang Don',
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Continuar com:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                      SizedBox(height: 10),
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
                          SizedBox(width: 15),
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/images/facebook.png",
                            ),
                            radius: 30,
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
