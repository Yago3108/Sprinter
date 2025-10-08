import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/entities/usuario.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Usuario? _user;

  final List<Usuario> _amigos = [];
  List<Usuario> get amigos => _amigos;

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

  Future<void> selecionarImagem() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
      if (imagem == null) return;

      final bytes = await imagem.readAsBytes();

      final base64Image = base64Encode(bytes);

      if (_user != null) {
        _user!.fotoPerfil = base64Image;
        await _firestore.collection('usuarios').doc(_user!.uid).update({
          'fotoPerfil': base64Image,
        });
        notifyListeners();
      }
    } catch (e) {
      print("Erro ao atualizar foto de perfil: $e");
    }
  }

  Future<void> carregarUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      _user = Usuario.fromMap(doc.data()!);
      notifyListeners();
    }
  }

}
