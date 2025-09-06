import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> selecionarImagem() async {
    final ImagePicker _picker = ImagePicker();
    try {
      // 1. Seleciona a imagem da galeria
      final XFile? imagem = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (imagem == null) return; // Usuário cancelou

      // 2. Converte para bytes
      final bytes = await imagem.readAsBytes();

      // 3. Converte para Base64
      final base64Image = base64Encode(bytes);

      // 4. Atualiza no Firestore
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

  Future<void> continuarComGoogle() async {
    notifyListeners();
  }

  Future<void> carregarUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      _user = Usuario.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  Map<String, dynamic>? getFotoPerfil() {
    if (_user == null) return null;
    return {'fotoPerfil': _user!.fotoPerfil};
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

  Future<String?> login(String email, String senha) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("Usuário não encontrado.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Senha incorreta.");
      } else if (e.code == 'invalid-email') {
        throw Exception("E-mail inválido.");
      } else {
        throw Exception("Erro ao logar: ${e.message}");
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> esqueceuSenha() async {
    await _auth.sendPasswordResetEmail(email: _user!.email);
    notifyListeners();
  }
}
