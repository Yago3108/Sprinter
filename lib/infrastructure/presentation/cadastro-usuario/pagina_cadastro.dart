import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/cadastro-usuario/estado_cadastro.dart';
import 'package:provider/provider.dart';
import '../login/pagina_login.dart';
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

  void verificarECadastrar() async {
    final provider = context.read<CadastroProvider>();

    final result = await provider.cadastrarUsuario(
      nome: controllerNome.text,
      cpf: controllerCpf.text,
      data: controllerData.text,
      email: controllerEmail.text,
      senha: controllerSenha.text,
    );

    if (result != null) {
      if (result == 'Erro ao cadastrar usuário') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erro no Cadastro"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(result),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaLogin()),
                  );
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CadastroProvider>();

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
                  error: provider.erroNome,
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
                    errorText: provider.erroCpf,
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
                    errorText: provider.erroData,
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
                  error: provider.erroEmail,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFieldComponente(
                  controller: controllerSenha,
                  hint: "Senha do Usuário",
                  label: "Senha",
                  error: provider.erroSenha,
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
                  error: provider.erroConfirmarSenha,
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaLogin())),
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
