import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_login.dart';
import 'package:myapp/infrastructure/presentation/widgets/button_componente.dart';
import 'package:myapp/infrastructure/presentation/widgets/outlined_button_navegacao.dart';
import 'package:myapp/infrastructure/presentation/widgets/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaEsqueceuSenha extends StatefulWidget {
  const PaginaEsqueceuSenha({Key? key}) : super(key: key);

  @override
  _PaginaEsqueceuSenhaState createState() => _PaginaEsqueceuSenhaState();
}

class _PaginaEsqueceuSenhaState extends State<PaginaEsqueceuSenha> {
  final TextEditingController _emailController = TextEditingController();
  
  String? _erroEmail;
  bool _isLoading = false;
  bool _emailEnviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> validarEmail() async {
    // Validação do email
    if (_emailController.text.isEmpty) {
      setState(() {
        _erroEmail = "Email não pode estar vazio";
      });
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() {
        _erroEmail = "Formato de email inválido";
      });
      return;
    }

    setState(() {
      _erroEmail = null;
      _isLoading = true;
    });

    try {
      await context.read<UserProvider>().esqueceuSenha();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailEnviado = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Link de recuperação enviado com sucesso!'),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Erro ao enviar email: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF056A0C).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Color(0xFF056A0C),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Esqueceu sua senha
                const Text(
                  "Esqueceu sua senha?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan',
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Mensagem
                Text(
                  "Não se preocupe! Digite seu email e enviaremos um link para redefinir sua senha",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontFamily: 'Lao Muang Don',
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Container Email
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
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
                        controller: _emailController,
                        prefixIcon: Icons.email,
                        hint: "seu@email.com",
                        label: "Email",
                        error: _erroEmail,
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // Botão Enviar
                      ButtonComponente(
                        text: "Enviar", 
                        function: () => validarEmail(),
                      ),
                      
                      // Botão Reenviar
                      if (_emailEnviado) ...[
                        const SizedBox(height: 15),
                        TextButton.icon(
                          onPressed: _isLoading ? null : validarEmail,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text(
                            "Reenviar email",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lao Muang Don',
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF056A0C),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                OutlinedButtonNavegacao(
                  function: () => Navigator.pop(context),
                  text2: "Voltar ao Login",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}