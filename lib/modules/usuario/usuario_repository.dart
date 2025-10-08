import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/entities/usuario.dart';

class UsuarioRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Usuario?> getUsuarioByUid(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      if(!doc.exists) return null;
      return Usuario.fromMap(doc.data()!);
    } catch(e) {
      return null;
    }
  }

  Future<void> registrarUsuario(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.uid).set(usuario.toMap());
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.uid).update(usuario.toMap());
  }

  Future<void> excluirUsuario(String uid) async {
    await _firestore.collection('usuarios').doc(uid).delete();
  }

  Future<List<Usuario>> listarUsuarios() async {
    final snapshot = await _firestore.collection('usuarios').get();
    return snapshot.docs.map((e) => Usuario.fromMap(e.data())).toList();
  }

  Future<UserCredential> login(String email, String senha) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<List<Usuario?>> carregarTodosAmigos(String uid) async {
    final snapshot = await _firestore
        .collection('usuarios')
        .where(uid)
        .get();
    return snapshot.docs.map((e) => Usuario.fromMap(e.data())).toList();
  }
}