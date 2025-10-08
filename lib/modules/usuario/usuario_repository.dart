import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/entities/usuario.dart';

class UsuarioRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // buscar usuário pelo uid
  Future<Usuario?> getUsuarioByUid(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if(!doc.exists) return null;
    return Usuario.fromMap(doc.data()!);
  }

  // buscar usuário pelo cpf
  Future<Usuario?> getUsuarioByCPF(String cpf) async {
    final doc = await _firestore.collection('usuarios').doc(cpf).get();
    if(!doc.exists) return null;
    return Usuario.fromMap(doc.data()!);
  }

  // buscar usuário pelo email
  Future<Usuario?> getUsuarioByEmail(String email) async {
    final doc = await _firestore.collection('usuarios').doc(email).get();
    if(!doc.exists) return null;
    return Usuario.fromMap(doc.data()!);
  }

  // registra o usuário
  Future<void> registrarUsuario(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.uid).set(usuario.toMap());
  }

  // atualiza o usuário
  Future<void> atualizarUsuario(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.uid).update(usuario.toMap());
  }

  // remove o usuário
  Future<void> excluirUsuario(String uid) async {
    await _firestore.collection('usuarios').doc(uid).delete();
  }

  // lista todos os usuários
  Future<List<Usuario>> listarUsuarios() async {
    final snapshot = await _firestore.collection('usuarios').get();
    return snapshot.docs.map((e) => Usuario.fromMap(e.data())).toList();
  }

  // faz login
  Future<UserCredential> login(String email, String senha) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  // faz log out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // reseta a senha
  Future<void> resetSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // carrega todos os amigos
  Future<List<Usuario?>> carregarTodosAmigos(String uid) async {
    final snapshot = await _firestore.collection('usuarios').where(uid).get();
    return snapshot.docs.map((e) => Usuario.fromMap(e.data())).toList();
  }
}