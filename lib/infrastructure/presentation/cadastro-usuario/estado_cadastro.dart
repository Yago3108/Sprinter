import 'package:flutter/material.dart';
import 'package:myapp/modules/usuario/usuario_usecase.dart';

class CadastroProvider with ChangeNotifier {
  CadastroProvider({required this.usuarioUseCase});

  final UsuarioUseCase usuarioUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _erroNome;
  String? _erroCpf;
  String? _erroData;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroConfirmarSenha;

  String? get erroNome => _erroNome;
  String? get erroCpf => _erroCpf;
  String? get erroData => _erroData;
  String? get erroEmail => _erroEmail;
  String? get erroSenha => _erroSenha;
  String? get erroConfirmarSenha => _erroConfirmarSenha;

  bool validarCampos({
    required String nome,
    required String cpf,
    required String data,
    required String email,
    required String senha,
    required String confirmarSenha,
  }) {
    _erroNome = usuarioUseCase.validarNome(nome);
    _erroCpf = usuarioUseCase.validarCPF(cpf);
    _erroData = usuarioUseCase.validarData(data);
    _erroEmail = usuarioUseCase.validarEmail(email);
    _erroSenha = usuarioUseCase.validarSenha(senha);
    _erroConfirmarSenha = usuarioUseCase.validarConfirmarSenha(senha, confirmarSenha);

    notifyListeners();

    return _erroNome == null && _erroCpf == null && _erroData == null &&
           _erroEmail == null && _erroSenha == null && _erroConfirmarSenha == null;
  }

  Future<String?> cadastrarUsuario({
    required String nome,
    required String cpf,
    required String data,
    required String email,
    required String senha,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await usuarioUseCase.cadastrarUsuario(nome, cpf, data, email);
      return result;
    } catch (e) {
      return 'Erro ao cadastrar usuário';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparErros() {
    _erroNome = null;
    _erroCpf = null;
    _erroData = null;
    _erroEmail = null;
    _erroSenha = null;
    _erroConfirmarSenha = null;
    notifyListeners();
  }
}