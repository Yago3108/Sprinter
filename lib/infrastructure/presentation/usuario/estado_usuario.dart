import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/entities/usuario.dart';

class UsuarioProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  UsuarioProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        await carregarUsuario(firebaseUser.uid);
      } else {
        _usuario = null;
        notifyListeners();
      }
    });
  }

  Future<void> carregarUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      _usuario = Usuario.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  void registrarUsuario(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }
}