import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/entities/usuario.dart';

abstract class IUsuarioUseCases {
  String? validarNome(String nome);

  String? validarCPF(String cpf);

  String? validarData(String data);

  String? validarEmail(String email);

  String? validarSenha(String senha);

  String? validarConfirmarSenha(String senha, String confirmarSenha);

  Future<String?> cadastrarUsuario(Usuario usuario);

  Future<UserCredential> logarUsuario(String email, String senha);
}