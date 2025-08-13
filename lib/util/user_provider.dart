import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/util/usuario.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Usuario? _user;

  Usuario? get user => _user;

  UserProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        await carregarUsuario(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> registrar({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String nascimento,
    double contPontos = 0,
    double contCarbono = 0,
    double distancia = 0,
    dynamic foto = 0,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final novoUsuario = Usuario(

        uid: cred.user!.uid,
        nome: nome,
        email: email,
        cpf: cpf,
        nascimento: nascimento,
        carboCoins: contPontos,
        carbono: contCarbono,
        distancia: distancia,
        fotoPerfil: foto,
      );

      await _firestore
          .collection('usuarios')
          .doc(cred.user!.uid)
          .set(novoUsuario.toMap());
      _user = novoUsuario;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> carregarUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      _user = Usuario.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  Map<String, dynamic>? getDistanciaEPontos() {
    if (_user == null) return null;
    return {'distancia': _user!.distancia, 'pontos': _user!.carboCoins};
  }

  Future<void> atualizarUsuario(Usuario novoUsuario) async {
    await _firestore
        .collection('usuarios')
        .doc(novoUsuario.uid)
        .update(novoUsuario.toMap());

    _user = novoUsuario;
    notifyListeners();
  }

  Future<UserCredential> login({
    required String email,
    required String senha,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
