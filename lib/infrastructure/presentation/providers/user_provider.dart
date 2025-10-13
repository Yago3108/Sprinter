import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/entities/usuario.dart';

class UserProvider extends ChangeNotifier {
  // instância de banco de dados
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // user e getter
  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  // amigos e getter
  final List<Usuario> _amigos = [];
  List<Usuario> get amigos => _amigos;

  // construtor
  UserProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        await carregarUsuario(firebaseUser.uid);
      } else {
        _usuario = null;
        notifyListeners();
      }
    });
  }

  Future<void> registrarUsuario(Usuario newUser) async {
    _usuario = newUser;
    notifyListeners();
  }

  // função para carregar o usuário
  Future<void> carregarUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      _usuario = Usuario.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  Future<void> selecionarImagem() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
      if (imagem == null) return;

      final bytes = await imagem.readAsBytes();

      final base64Image = base64Encode(bytes);

      if (_usuario != null) {
        _usuario!.fotoPerfil = base64Image;
        await _firestore.collection('usuarios').doc(_usuario!.uid).update({
          'fotoPerfil': base64Image,
        });
        notifyListeners();
      }
    } catch (e) {
      print("Erro ao atualizar foto de perfil: $e");
    }
  }

}
