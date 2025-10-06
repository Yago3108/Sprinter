import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
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

  String? erroNome;
  String? erroEmail;
  String? erroCPF;
  String? erroData;
  String? erroSenha;
  String? erroConfirmarSenha;

  bool nomeValido = true;
  bool emailValido = true;
  bool cpfValido = true;
  bool dataValida = true;
  bool senhaValida = true;
  bool confirmarSenhaValida = true;
  bool _obscureTextSenha = true;
  bool _obscureTextConfirmarSenha = true;

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

  bool validarData(String date) {
    try {
      DateFormat format = DateFormat("dd/MM/yyyy");
      DateTime data = format.parseStrict(date);

      final agora = DateTime.now();
      if (data.isAfter(agora)) return false;
      if (data.year < 1900) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      helpText: "Selecione a sua data de nascimento",
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataSelecionada != null) {
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSelecionada);
      setState(() {
        controllerData.text = dataFormatada;
      });
    }
  }

  void verificarECadastrar() {
    setState(() {
      if (controllerNome.text.isEmpty) {
        nomeValido = false;
        erroNome = "O nome não pode estar vazio";
      } else {
        nomeValido = true;
        erroNome = null;
      }

      if (controllerEmail.text.isEmpty) {
        emailValido = false;
        erroEmail = "O Email não pode estar vazio";
      } else if (!controllerEmail.text.contains("@")) {
        emailValido = false;
        erroEmail = "O Email precisa ter @";
      } else {
        emailValido = true;
        erroEmail = null;
      }

      if (controllerCpf.text.isEmpty) {
        cpfValido = false;
        erroCPF = "O CPF não pode estar vazio";
      } else if (!CPFValidator.isValid(controllerCpf.text)) {
        cpfValido = false;
        erroCPF = "CPF inválido";
      } else {
        cpfValido = true;
        erroCPF = null;
      }

      if (controllerData.text.isEmpty) {
        dataValida = false;
        erroData = "A data não pode estar vazia";
      } else if (controllerData.text.length != 10) {
        dataValida = false;
        erroData = "A data precisa conter 8 dígitos";
      } else if (!validarData(controllerData.text)) {
        dataValida = false;
        erroData = "Data inválida";
      } else {
        dataValida = true;
        erroData = null;
      }

      if (controllerSenha.text.isEmpty) {
        senhaValida = false;
        erroSenha = "A senha não pode estar vazia";
      } else if (controllerSenha.text.length < 8) {
        senhaValida = false;
        erroSenha = "A senha precisa ter, pelo menos, 8 dígitos";
      } else {
        senhaValida = true;
        erroSenha = null;
      }

      if (controllerConfirmarSenha.text.isEmpty) {
        confirmarSenhaValida = false;
        erroConfirmarSenha = "Confirmar senha não pode estar vazio";
      } else if (controllerConfirmarSenha.text != controllerSenha.text) {
        confirmarSenhaValida = false;
        erroConfirmarSenha = "Senhas não correspondentes";
      } else {
        confirmarSenhaValida = true;
        erroConfirmarSenha = null;
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
        contPontos: 0,
        foto: 0,
      );
      login();
    }
  }

  void login() {
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset("assets/images/Logo_Sprinter.png", height: 75),
              Padding(padding: EdgeInsets.only(top: 15)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: controllerNome,
                  decoration: InputDecoration(
                    labelText: ("Nome de usuário"),
                    errorText: erroNome,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira o seu nome:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 40)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    labelText: ("Email:"),
                    errorText: erroEmail,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira seu E-mail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: controllerData,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ("Data de Nascimento:"),
                    errorText: erroData,
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: controllerCpf,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ("CPF:"),
                    errorText: erroCPF,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "000.000.000-00",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: controllerSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ("Senha:"),
                    errorText: erroSenha,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextSenha = !_obscureTextSenha;
                        });
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira sua Senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: controllerConfirmarSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ("Confirmar senha:"),
                    errorText: erroConfirmarSenha,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirmarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirmarSenha =
                              !_obscureTextConfirmarSenha;
                        });
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lao Muang Don',
                    ),
                    hintText: "Insira sua senha novamente",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(1000, 5, 106, 12),
                ),
                onPressed: () => verificarECadastrar(),
                child: Container(
                  height: 50,
                  width: 320,
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
    );
  }
}
