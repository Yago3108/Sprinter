import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/entities/usuario.dart';

class UsuarioRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Usuario?> getUsuarioByUid(String uid) async {
    try {
      final doc = await firestore.collection('usuarios').doc(uid).get();
      if(!doc.exists) return null;
      return Usuario.fromMap(doc.data()!);
    } catch(e) {
      return null;
    }
  }

  Future<void> registrarUsuario(Usuario usuario) async {
    await firestore.collection('usuarios').doc(usuario.uid).set(usuario.toMap());
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    await firestore.collection('usuarios').doc(usuario.uid).update(usuario.toMap());
  }

  Future<void> excluirUsuario(String uid) async {
    await firestore.collection('usuarios').doc(uid).delete();
  }

  Future<List<Usuario>> listarUsuarios() async {
    final snapshot = await firestore.collection('usuarios').get();
    return snapshot.docs.map((e) => Usuario.fromMap(e.data())).toList();
  }

  Future<UserCredential> login(String email, String senha) async {
    return await auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> resetSenha(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}