import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina.dart';
import 'package:myapp/pages/pagina_cadastro.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  bool nomeValido = false;
  bool senhaValida = false;
  void cadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaCadastro()),
    );
  }
void esqueceuSenha() {

  }
  void verificarELogar() {
    String senha = controllerSenha.text;
    if (controllerNome.text.contains('@')) {
      nomeValido = true;
    } else {
      nomeValido = true;
    }
    if (senha.length >= 8) {
      senhaValida = true;
    } else {
      senhaValida = false;
    }

    if (nomeValido && senhaValida) {
      try {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).login(email: controllerNome.text, senha: controllerSenha.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Pagina()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
        children: [Column(
          children: [
            SizedBox(height: 20),
            //imagem
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Image.asset("assets/images/Logo_Sprinter.png", height: 75),
            ), //textfields
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 20, left: 30, right: 30),
              child: Column(
                children: [
                  //Nome
                  TextField(
                    controller: controllerNome,
                    decoration: InputDecoration(
                      labelText: ("E-mail / nome de usuário"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Lao Muang Don',
                      ),
                      hintText: "Insira o nome ou Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsetsGeometry.only(top: 30)),
                  TextField(
                    controller: controllerSenha,
                    decoration: InputDecoration(
                      labelText: ("Senha"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Lao Muang Don',
                      ),
                      hintText: "Insira a senha",
                      counter: TextButton(
                      onPressed: esqueceuSenha, child:Container(
                        height: 20 , padding: EdgeInsets.only(left: 5), child: Text("Esqueceu a senha?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Lao Muang Don',
                      ),
                      ),)
                      ),
                   
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top:20)),

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
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/google.png"),
                        radius: 30,
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
      ],),),
    );
  }

  
}
