import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/widgets/button_componente.dart';
import 'package:myapp/infrastructure/presentation/widgets/outlined_button_navegacao.dart';
import 'package:myapp/infrastructure/presentation/widgets/textfield_componente.dart';
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
  // Controllers
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();
  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfirmarSenha = TextEditingController();

  // Erros
  String? _erroNome;
  String? _erroCPF;
  String? _erroData;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroConfirmarSenha;

  // Limpa os Controllers
  void clearControllers() {
    setState(() {
      _controllerNome.clear();
      _controllerCpf.clear();
      _controllerData.clear();
      _controllerEmail.clear();
      _controllerSenha.clear();
      _controllerConfirmarSenha.clear();
    });
  }

  // Limpa os erros
  void clearErros() {
    setState(() {
      _erroNome = null;
      _erroCPF = null;
      _erroData = null;
      _erroEmail = null;
      _erroSenha = null;
      _erroConfirmarSenha = null;
    });
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerCpf.dispose();
    _controllerData.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerConfirmarSenha.dispose();
    super.dispose();
  }

  // DatePicker
  Future<void> _selecionarData(BuildContext context) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      helpText: "Selecione sua data de nascimento",
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 5, 106, 12),
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

  // Verificação e Cadastro do Usuário
  void verificarECadastrar() async {
    final userProvider = context.read<UserProvider>();
    final usuarioEmail = await userProvider.getUsuarioByEmail(_controllerEmail.text);

    setState(() {
      // Validação do Nome
      if (_controllerNome.text.isEmpty) {
        _erroNome = "Nome não pode estar vazio";
      } else {
        _erroNome = null;
      }

      // Validação do CPF
      if (_controllerCpf.text.isEmpty) {
        _erroCPF = "CPF não pode estar vazio";
      } else if (_controllerCpf.text.length <= 11) {
        _erroCPF = "CPF deve ter 11 números";
      } else if (!CPFValidator.isValid(_controllerCpf.text)) {
        _erroCPF = "CPF inválido";
      } else {
        _erroCPF = null;
      }

      // Validação da Data
      if (_controllerData.text.isEmpty) {
        _erroData = "Data não pode estar vazia";
      } else {
        _erroData = null;
      }

      // Validação do Email
      if (_controllerEmail.text.isEmpty) {
        _erroEmail = "Email não pode estar vazio";
      } else if (!RegExp(r'^(?!.*[A-Z])[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_controllerEmail.text)) {
        _erroEmail = "Formato de email inválido";
      } else if (usuarioEmail) {
        _erroEmail = "Email já cadastrado";
      } else {
        _erroEmail = null;
      }

      // Validação da Senha
      if (_controllerSenha.text.isEmpty) {
        _erroSenha = "Senha não pode estar vazia";
      } else if (_controllerSenha.text.length < 8) {
        _erroSenha = "Senha deve ter pelo menos 8 caracteres";
      } else {
        _erroSenha = null;
      }

      // Validação da Confirmação de Senha
      if (_controllerConfirmarSenha.text.isEmpty) {
        _erroConfirmarSenha = "Confirmar senha não pode estar vazia";
      } else if (_controllerSenha.text != _controllerConfirmarSenha.text) {
        _erroConfirmarSenha = "As senhas não coincidem";
      } else {
        _erroConfirmarSenha = null;
      }
    });

    // Se não houver erros, tenta cadastrar o usuário
    if (_erroNome == null && _erroEmail == null && _erroCPF == null && _erroData == null && _erroSenha == null && _erroConfirmarSenha == null) {
      try {
        await userProvider.registrar(
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
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaginaLogin()));
        clearControllers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text("Erro Inesperado! Tente novamente.", style: TextStyle(color: Colors.black)),
              ],
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            clearControllers();
            clearErros();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo
              Image.asset("assets/images/Logo_Sprinter.png", height: 70),

              const SizedBox(height: 30),
              
              // Nome
              TextFieldComponente(
                controller: _controllerNome,
                prefixIcon: Icons.person,
                hint: "Digite seu nome completo",
                label: "Nome Completo",
                error: _erroNome,
              ),
              
              const SizedBox(height: 20),
              
              // CPF
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "CPF",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Lao Muang Don',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _controllerCpf,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "000.000.000-00",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(Icons.perm_identity, color: _erroCPF == null ? Color.fromARGB(255, 5, 106, 12) : Colors.red[400]),
                      errorText: _erroCPF,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 5, 106, 12),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 5, 106, 12),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Data
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Data de Nascimento",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Lao Muang Don',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _controllerData,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "DD/MM/AAAA",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: _erroData == null ? Color.fromARGB(255, 5, 106, 12) : Colors.red[400],
                        ),
                        onPressed: () => _selecionarData(context),
                      ),
                      errorText: _erroData,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 5, 106, 12),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 5, 106, 12),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              
              // Email
              TextFieldComponente(
                controller: _controllerEmail,
                prefixIcon: Icons.email,
                hint: "seu@email.com",
                label: "Email",
                error: _erroEmail,
              ),

              const SizedBox(height: 20),
              
              // Senha
              TextFieldComponente(
                controller: _controllerSenha,
                prefixIcon: Icons.lock,
                hint: "••••••••",
                label: "Senha",
                error: _erroSenha,
                isPassword: true,
              ),
              
              const SizedBox(height: 20),
              
              // Confirmar Senha
              TextFieldComponente(
                controller: _controllerConfirmarSenha,
                prefixIcon: Icons.lock,
                hint: "••••••••",
                label: "Confirmar Senha",
                error: _erroConfirmarSenha,
                isPassword: true,
              ),

              const SizedBox(height: 30),
              
              // Botão Cadastrar
              ButtonComponente(
                text: "Cadastrar", 
                function: verificarECadastrar,
              ),

              const SizedBox(height: 15),

              // Botão de Navegação para Login
              OutlinedButtonNavegacao(
                function: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaLogin()));
                  clearControllers();
                  clearErros();
                }, 
                text1: "Já tem uma conta? ", 
                text2: "Faça login",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}