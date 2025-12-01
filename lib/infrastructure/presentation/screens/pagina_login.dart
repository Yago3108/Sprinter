import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/widgets/button_componente.dart';
import 'package:myapp/infrastructure/presentation/widgets/outlined_button_navegacao.dart';
import 'package:myapp/infrastructure/presentation/widgets/textfield_componente.dart';
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
  // Controllers
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  // Erros
  String? _erroEmail;
  String? _erroSenha;

  // Limpa os Controllers
  void clearControllers() {
    setState(() {
      _controllerEmail.clear();
      _controllerSenha.clear();
    });
  }

  // Limpa os erros
  void clearErros() {
    setState(() {
      _erroEmail = null;
      _erroSenha = null;
    });
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  // Verificação e Login
  void verificarELogar() async {
    setState(() {
      // Validação de Email
      if (!RegExp(r'^(?!.*[A-Z])[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_controllerEmail.text)) {
        _erroEmail = "Email inválido";
      } else {
        _erroEmail = null;
      } 

      // Validação de Senha
      if (_controllerSenha.text.isEmpty || _controllerSenha.text.length < 8) {
        _erroSenha = "Senha inválida";
      } else {
        _erroSenha = null;
      }
    });

    // Se não houver erros, tenta o login
    if (_erroEmail == null && _erroSenha == null) {
      final userProvider = context.read<UserProvider>();

      try {
        final user = await userProvider.login(
          _controllerEmail.text,
          _controllerSenha.text,
        );

        // Se o usuário existir, carrega o usuário e navega pra página iniciaç
        if (user != null) {
          await userProvider.carregarUsuario(user.uid);
           userProvider.sortearDica();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Pagina()));

          _controllerEmail.clear();
          _controllerSenha.clear();
        } else {
          // Senão, mostra aviso ao usuário
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Email ou Senha inválidos!", style: TextStyle(color: Colors.black)),
                ],
              ),
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } catch (e) {
        // Caso dê algum erro inesperado
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              // Logo
              Image.asset("assets/images/Logo_Sprinter.png", height: 90),

              const SizedBox(height: 20),

              // Container Text Field
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    width: 2,
                    color: Color.fromARGB(255, 5, 106, 12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
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

                    // Esqueceu sua senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaEsqueceuSenha()));
                          clearControllers();
                          clearErros();
                        },
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(
                            color: Color.fromARGB(1000, 5, 106, 12),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Lao Muang Don",
                          ),
                        ),
                      ),
                    ),

                    // Botão Entrar
                    ButtonComponente(
                      text: "Entrar",
                      function: verificarELogar,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  const SizedBox(width: 8),
                  Text(
                    "ou",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 20),

              // Botão de Navegação para Login
              OutlinedButtonNavegacao(
                function: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaCadastro()));
                  clearControllers();
                  clearErros();
                },
                text1: "Não tem uma conta? ", 
                text2: "Cadastre-se!",
              ),
            ],
          ),
        ),
      ),
    );
  }
}