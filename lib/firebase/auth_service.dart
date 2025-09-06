import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String dataNascimento,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      User? user = result.user;

      if (user != null) {
        await _db.collection("usuarios").doc(user.uid).set({
          "nome": nome,
          "email": email,
          "cpf": cpf,
          "dataNascimento": dataNascimento,
          "uid": user.uid,
          "criadoEm": FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print("Erro ao registrar: $e");
      return null;
    }
  }
}
