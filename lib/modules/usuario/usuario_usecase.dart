import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:myapp/modules/usuario/usuario_spec.dart';

class UsuarioUseCase {
  UsuarioUseCase(this._repository);

  final UsuarioRepository _repository;

  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  String? validarCPF(String cpf) {
    if (cpf.isEmpty) {
      return "O CPF não pode estar vazio";
    } else if (!CPFValidator.isValid(cpf)) {
      return "CPF inválido";
    }
    return null;
  }

  bool validarTempo(String date) {
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

  String? validarData(String data) {
    if (data.isEmpty) {
      return "A data não pode estar vazia";
    } else if (data.length != 10) {
      return "A data precisa conter 8 dígitos";
    } else if (!validarTempo(data)) {
      return "Data inválida";
    }
    return null;
  }

  String? validarEmail(String email) {
    if (email.isEmpty) {
      return "O Email não pode estar vazio";
    } else if (!email.contains("@")) {
      return "O Email precisa ter @";
    }
    return null;
  }

  String? validarSenha(String senha) {
    if (senha.isEmpty) {
      return "A senha não pode estar vazia";
    } else if (senha.length < 8) {
      return "A senha precisa ter, pelo menos, 8 dígitos";
    }
    return null;
  }

  String? validarConfirmarSenha(String senha, String confirmarSenha) {
    if (confirmarSenha.isEmpty) {
      return "Confirmar senha não pode estar vazio";
    } else if (confirmarSenha != senha) {
      return "Senhas não correspondentes";
    }
    return null;
  }

  Future<String?> cadastrarUsuario(String nome, String cpf, String data, String email) async {
    try {
      final result1 = await _repository.getUsuarioByEmail(email);
      if(result1 != null) return "Email já existente";

      final result2 = await _repository.getUsuarioByCPF(cpf);
      if(result2 != null) return "CPF já existente";

      Usuario usuario = Usuario(
        amigos: [], 
        uid: "", 
        nome: nome, 
        email: email, 
        cpf: cpf, 
        nascimento: data, 
        carboCoins: 0, 
        carbono: 0, 
        distancia: 0,
      );

      await _repository.registrarUsuario(usuario);
      return null;
    } catch(e) {
      return "Erro no Cadastro do Usuário";
    }
  }

  Future<Usuario?> logarUsuario(String email, String senha) async {
    try {
      final result = await _repository.login(email, senha);
      User user = result.user!;
      Usuario usuario = Usuario.fromFirebaseUser(user);
      return usuario;
    } catch (e) {
      return null;
    }
  }

  Future<void> deslogarUsuario() async {
    await _repository.logout();
  }
}