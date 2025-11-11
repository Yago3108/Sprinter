import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
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
  // controllers
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();
  TextEditingController _controllerData = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmarSenha = TextEditingController();

  // variáveis de erro
  String? _erroNome;
  String? _erroCPF;
  String? _erroData;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroConfirmarSenha;

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
        _controllerData.text = dataFormatada;
      });
    }
  }

  // função para verificações e cadastrar o usuário no banco de dados
  void verificarECadastrar() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final usuarioEmail = await userProvider.getUsuarioByEmail(_controllerEmail.text);

    setState(() {
      if(_controllerNome.text.isEmpty) {
        _erroNome = "Nome não pode estar vazio";
      } else {
        _erroNome = null;
      }

      if(_controllerCpf.text.isEmpty) {
        _erroCPF = "CPF não pode estar vazio";
      } else if(_controllerCpf.text.length<=11) {
        _erroCPF = "CPF tem que ter 11 números";
      } else if(!CPFValidator.isValid(_controllerCpf.text)) {
        _erroCPF = "CPF inválido";
      } else {
        _erroCPF = null;
      }

      if(_controllerData.text.isEmpty) {
        _erroData = "Data não pode estar vazio";
      } else {
        _erroData = null;
      }

      if(_controllerEmail.text.isEmpty) {
        _erroEmail = "Email não pode estar vazio";
      }
       else if(!RegExp(r'^(?!.*[A-Z])[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_controllerEmail.text)) {
        _erroEmail = "Formato de Email inválido";
      }else if(usuarioEmail){
        _erroEmail="Email já cadastrado";
      }else {
        _erroEmail = null;
      }

      if(_controllerSenha.text.isEmpty) {
        _erroSenha = "Senha não pode estar vazia";
      } else if(_controllerSenha.text.length < 8) {
        _erroSenha = "Senha tem que ter 8 dígitos";
      } else {
        _erroSenha = null;
      }

      if(_controllerConfirmarSenha.text.isEmpty) {
        _erroConfirmarSenha = "Confirmar senha não pode estar vazia";
      } else if(_controllerSenha.text != _controllerConfirmarSenha.text) {
        _erroConfirmarSenha = "Confirmar Senha diferente da Senha";
      } else {
        _erroConfirmarSenha = null;
      }
    });

    if (_erroNome == null &&
        _erroEmail == null &&
        _erroCPF == null &&
        _erroData == null &&
        _erroSenha == null &&
        _erroConfirmarSenha == null) {
    
      userProvider.registrar(
        nome: _controllerNome.text,
        email: _controllerEmail.text,
        senha: _controllerSenha.text,
        cpf: _controllerCpf.text,
        nascimento: _controllerData.text,
        distancia: 0.0,
        contCarbono: 0,
        contPontos: 0,
        foto: "",
      );
      login();
    }
  }

  // função para ir a tela de login e limpar os text fields
  void login() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaLogin()));
    setState(() {
      _controllerConfirmarSenha.clear();
      _controllerData.clear();
      _controllerEmail.clear();
      _controllerNome.clear();
      _controllerSenha.clear();
      _controllerCpf.clear();
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
                  controller: _controllerNome, 
                  hint: "Nome do Usuário", 
                  label: "Nome",
                  error: _erroNome,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: _controllerCpf,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ("CPF:"),
                    errorText: _erroCPF,
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
                  controller: _controllerData,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: ("Data de Nascimento:"),
                    errorText: _erroData,
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
                  controller: _controllerEmail,
                  hint: "Email do Usuário",
                  label: "Email",
                  error: _erroEmail,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFieldComponente(
                  controller: _controllerSenha,
                  hint: "Senha do Usuário",
                  label: "Senha",
                  error: _erroSenha,
                  isPassword: true,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFieldComponente(
                  controller: _controllerConfirmarSenha,
                  hint: "Confirmar a Senha do Usuário",
                  label: "Confirmar Senha",
                  error: _erroConfirmarSenha,
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
