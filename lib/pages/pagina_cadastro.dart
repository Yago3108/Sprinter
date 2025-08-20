import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';
import 'pagina_login.dart';
import 'package:intl/intl.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCpf = TextEditingController();
  TextEditingController controllerData = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerConfirmarSenha = TextEditingController();
  bool nomeValido = true;
  bool emailValido = true;
  bool cpfValido = true;
  bool dataValida = true;
  bool senhaValida = true;
  bool confirmarSenhaValida = true;
  List<String> caracteresEspeciais = [
    "! ",
    "\"",
    "#",
    "\$",
    "%",
    "&",
    "'",
    "(",
    ")",
    "*",
    "+",
    ",",
    "-",
    ".",
    "/",
    ":",
    ";",
    "<",
    "=",
    ">",
    "?",
    "@",
    "[",
    "\"",
    "]",
    "^",
    "_",
    "`",
    "{",
    "|",
    "}",
    "~",
  ];

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale("pt", "BR"),
    );

    if (dataSelecionada != null) {
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSelecionada);
      setState(() {
        controllerData.text = dataFormatada;
      });
    }
  }

  verificarECadastrar() {
    String nome = controllerNome.text;
    String email = controllerEmail.text;
    String data = controllerData.text;
    String senha = controllerSenha.text;
    String confirmarSenha = controllerConfirmarSenha.text;

    setState(() {
      for (int i = 0; i < nome.length; i++) {
        if (caracteresEspeciais.contains(nome[i])) {
          nomeValido = false;
          break;
        }
      }

      if (email.contains('@') && email.contains('.')) {
        emailValido = true;
      } else {
        emailValido = false;
      }

      cpfValido = CPFValidator.isValid(controllerCpf.text);

      try {
        final datadiv = data.split('/');
        if (datadiv.length == 3) {
          final dia = int.parse(datadiv[0]);
          final mes = int.parse(datadiv[1]);
          final ano = int.parse(datadiv[2]);

          final dataC = DateTime(ano, mes, dia);
          if (dataC.day == dia && dataC.month == mes && dataC.year == ano) {
            dataValida = true;
          } else {
            dataValida = false;
          }
        } else {
          dataValida = false;
        }
      } catch (e) {
        dataValida = false;
      };

      if (senha.length >= 8) {
        senhaValida = true;
      } else {
        senhaValida = false;
      }

      if (senha == confirmarSenha) {
        confirmarSenhaValida = true;
      } else {
        confirmarSenhaValida = false;
      }
    });

    if (nomeValido &&
        emailValido &&
        cpfValido &&
        dataValida &&
        senhaValida &&
        confirmarSenhaValida) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.registrar(
        nome: controllerNome.text,
        email: controllerEmail.text,
        senha: controllerSenha.text,
        cpf: controllerCpf.text,
        nascimento: controllerData.text,
        distancia: 0.0,
        contCarbono: 0.0,
        contPontos: 0.0,
        foto: 0,
      );
      login();
    }
  }

  login() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaginaLogin()),
      );
      controllerConfirmarSenha.clear();
      controllerData.clear();
      controllerEmail.clear();
      controllerNome.clear();
      controllerSenha.clear();
      controllerCpf.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset("assets/images/Logo_Sprinter.png", height: 75),
                Padding(padding: EdgeInsets.only(top: 15)),
                TextField(
                  controller: controllerNome,
                  decoration: InputDecoration(
                    labelText: ("Nome de usuário"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira o seu nome:",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: nomeValido ? Colors.black : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: nomeValido ? Colors.black : Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 20)),
                TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    labelText: ("Email:"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira seu E-mail",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: emailValido ? Colors.black : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: nomeValido ? Colors.black : Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  controller: controllerData,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ("Data de Nascimento:"),
                    suffixIcon: IconButton(
                      onPressed: () => _selecionarData(context),
                      icon: Icon(Icons.calendar_today),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "DD/MM/YYYY",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: dataValida ? Colors.black : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: dataValida ? Colors.black : Colors.red,
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  controller: controllerCpf,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ("CPF:"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "000.000.000-00",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: cpfValido ? Colors.black : Colors.red,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: cpfValido ? Colors.black : Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),

                TextField(
                  controller: controllerSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ("Senha:"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira sua Senha",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: senhaValida ? Colors.black : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: cpfValido ? Colors.black : Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 20)),
                TextField(
                  controller: controllerConfirmarSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ("Confirmar senha:"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira sua senha novamente",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: confirmarSenhaValida ? Colors.black : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(
                        color: cpfValido ? Colors.black : Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(1000, 5, 106, 12),
                  ),
                  onPressed: () => verificarECadastrar(),
                  child: Container(
                    height: 50,
                    width: 319,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "CADASTRAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Lao Muang Don',
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => login(),
                  child: Text(
                    "Já tem uma conta? Faça login!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Lao Muang Don',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
