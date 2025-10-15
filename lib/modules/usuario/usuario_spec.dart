import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/entities/usuario.dart';

abstract class IUsuarioRepository {
  Future<Usuario?> getUsuarioByUid(String uid);
  Future<Usuario?> getUsuarioByCPF(String cpf);
  Future<Usuario?> getUsuarioByEmail(String email);
  Future<void> registrarUsuario(Usuario usuario);
  Future<void> atualizarUsuario(Usuario usuario);
  Future<void> excluirUsuario(String uid);
  Future<List<Usuario>> listarUsuarios();
  Future<UserCredential> login(String email, String senha);
  Future<void> logout();
  Future<void> resetSenha(String email);
  Future<List<Usuario?>> carregarTodosAmigos(String uid);
}