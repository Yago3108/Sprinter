import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/modules/usuario/usuario_usecases.dart';
import 'package:provider/provider.dart';
import 'pagina_login.dart';
import 'package:intl/intl.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  // controllers
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCpf = TextEditingController();
  TextEditingController controllerData = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerConfirmarSenha = TextEditingController();

  // variáveis de erro
  String? erroNome;
  String? erroCPF;
  String? erroData;
  String? erroEmail;
  String? erroSenha;
  String? erroConfirmarSenha;

  final UsuarioUseCases usuarioUseCases = UsuarioUseCases();

  // DatePicker para selecionar a data
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

  // função para verificações e cadastrar o usuário no banco de dados
  void verificarECadastrar() {
    setState(() {
      erroNome = usuarioUseCases.validarNome(controllerNome.text);
      erroCPF = usuarioUseCases.validarCPF(controllerCpf.text);
      erroData = usuarioUseCases.validarData(controllerData.text);
      erroEmail = usuarioUseCases.validarEmail(controllerEmail.text);
      erroSenha = usuarioUseCases.validarSenha(controllerSenha.text);
      erroConfirmarSenha = usuarioUseCases.validarConfirmarSenha(controllerSenha.text, controllerConfirmarSenha.text);
    });

    if (erroNome == null &&
        erroEmail == null &&
        erroCPF == null &&
        erroData == null &&
        erroSenha == null &&
        erroConfirmarSenha == null) {
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

  // função para ir a tela de login e limpar os text fields
  void login() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaLogin()));
    setState(() {
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
              Padding(padding: EdgeInsets.only(top: 80)),
              Image.asset("assets/images/Logo_Sprinter.png", height: 75),
              Padding(padding: EdgeInsets.only(top: 30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFieldComponente(
                  controller: controllerNome, 
                  hint: "Nome do Usuário", 
                  label: "Nome",
                  error: erroNome,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
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
                child: TextFieldComponente(
                  controller: controllerEmail,
                  hint: "Email do Usuário",
                  label: "Email",
                  error: erroEmail,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFieldComponente(
                  controller: controllerSenha,
                  hint: "Senha do Usuário",
                  label: "Senha",
                  error: erroSenha,
                  isPassword: true,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFieldComponente(
                  controller: controllerConfirmarSenha,
                  hint: "Confirmar a Senha do Usuário",
                  label: "Confirmar Senha",
                  error: erroConfirmarSenha,
                  isPassword: true,
                )
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () => verificarECadastrar(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    backgroundColor: Color.fromARGB(1000, 5, 106, 12),
                  ), 
                  child: const Text("Cadastrar", style: 
                    TextStyle(
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
              Padding(padding: EdgeInsets.only(top: 50)),
            ],
          ),
        ),
      ),
    );
  }
}
