import 'package:flutter/material.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:myapp/modules/usuario/usuario_usecase.dart';

class LoginProvider with ChangeNotifier {
  LoginProvider({required this.usuarioUseCase});

  final UsuarioUseCase usuarioUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _erroEmail;
  String? _erroPassword;

  String? get erroEmail => _erroEmail;
  String? get erroPassword => _erroPassword;

  bool validarCampos(String email, String password) {
    _erroEmail = usuarioUseCase.validarEmail(email);
    _erroPassword = usuarioUseCase.validarSenha(password);
    
    notifyListeners();
    
    return _erroEmail == null && _erroPassword == null;
  }

  Future<Usuario?> fazerLogin(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await usuarioUseCase.logarUsuario(email, password);
      return user;
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparErros() {
    _erroEmail = null;
    _erroPassword = null;
    notifyListeners();
  }
}