import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';
import 'package:myapp/modules/usuario/usuario_spec.dart';

class UsuarioUseCases implements IUsuarioUseCases {

  // validação de nome
  @override
  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  // validação de CPF  
  @override
  String? validarCPF(String cpf) {
    if (cpf.isEmpty) {
      return "O CPF não pode estar vazio";
    } else if (!CPFValidator.isValid(cpf)) {
      return "CPF inválido";
    }

    return null;
  }

  // função para validar o tempo em que a pessoa nasceu
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

  // validação de data
  @override
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

  // validação de email
  @override
  String? validarEmail(String email) {
    if (email.isEmpty) {
      return "O Email não pode estar vazio";
    } else if (!email.contains("@")) {
      return "O Email precisa ter @";
    }

    return null;
  }

  // validação de senha
  @override
  String? validarSenha(String senha) {
    if (senha.isEmpty) {
      return "A senha não pode estar vazia";
    } else if (senha.length < 8) {
      return "A senha precisa ter, pelo menos, 8 dígitos";
    }

    return null;
  }

  // validação de confirmar senha
  @override
  String? validarConfirmarSenha(String senha, String confirmarSenha) {
    if (confirmarSenha.isEmpty) {
      return "Confirmar senha não pode estar vazio";
    } else if (confirmarSenha != senha) {
      return "Senhas não correspondentes";
    }

    return null;
  }
}