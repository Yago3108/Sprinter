import 'package:myapp/entities/usuario.dart';

abstract class IUsuarioUseCases {
  String? validarNome(String nome);

  String? validarCPF(String cpf);

  String? validarData(String data);

  String? validarEmail(String email);

  String? validarSenha(String senha);

  String? validarConfirmarSenha(String senha, String confirmarSenha);

  Future<String?> cadastrarUsuario(String nome, String cpf, String data, String email);

  Future<Usuario?> logarUsuario(String email, String senha);

  Future<void> deslogarUsuario();
}