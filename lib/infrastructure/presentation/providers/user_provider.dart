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
    int contPontos = 0,
    double contCarbono = 0,
    double distancia = 0,
    String foto = "",
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final novoUsuario = Usuario(
        amigos: amigos,
        uid: cred.user!.uid,
        nome: nome,
        email: email,
        cpf: cpf,
        nascimento: nascimento,
        carboCoins: contPontos,
        carbono: contCarbono,
        distancia: distancia,
        fotoPerfil: "",
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
      //Seleciona a imagem da galeria
      final XFile? imagem = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (imagem == null) return; // Usuário cancelou

      //Converte para bytes
      final bytes = await imagem.readAsBytes();

      //Converte para Base64
      final base64Image = base64Encode(bytes);

      //Atualiza no Firestore
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

  Map<String, dynamic>? getFotoPerfil() {
    if (_user == null) return null;
    return {'fotoPerfil': _user!.fotoPerfil};
  }
  Future<bool> getUsuarioByEmail(String email) async {
    try {
      final doc = await _firestore.collection('usuarios')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
      

      
      return doc.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  Future<void> atualizarUsuario(Usuario novoUsuario) async {
    await _firestore
        .collection('usuarios')
        .doc(novoUsuario.uid)
        .update(novoUsuario.toMap());

    _user = novoUsuario;
    carregarUsuario(_user!.uid);
    notifyListeners();
  }

  Future<User?> login(String email, String senha) async {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha);
    final user = userCredential.user;

    if(user != null) {
      return user;
    }

    return null;
  }

  Usuario? usuarioPesquisado;
  
  Future<Usuario?> getUsuarioByUid(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists) {
      final data = doc.data()!;

      usuarioPesquisado = Usuario(
        uid: data['uid'],
        nome: data['nome'],
        email: data['email'],
        cpf: data['cpf'],
        nascimento: data['nascimento'],
        carboCoins: (data['carboCoins'] ?? 0).round(),
        carbono: (data['carbono'] ?? 0).toDouble(),
        distancia: (data['distancia'] ?? 0).toDouble(),
        fotoPerfil: base64Decode(data['Foto_perfil']),
        amigos: [],
      );
     
      notifyListeners();
      }

     

   
    } catch (e) {
      print("Erro ao buscar usuário por UID: $e");

    }
  }
  final List<Usuario> _amigos = [];
  List<Usuario> get amigos => _amigos;

  Future<void> carregarTodosAmigos() async {
    if (_user == null) return;

    final snapshot = await _firestore
        .collection('usuarios')
        .where(user!.uid)
        .get();

    _amigos.clear();
    for (var doc in snapshot.docs) {
      _amigos.add(Usuario.fromMap(doc.data()));
    }
    notifyListeners();
  }
     
    void atualizarCC(int pontos, double emissao, double distancia){
      Usuario user = _user!;  
      user.distancia += distancia;
      user.carboCoins += pontos;
      user.carbono += emissao;
      atualizarUsuario(user);
    }

    void retirarCC(int pontos){
      Usuario user = _user!;
      user.carboCoins = user.carboCoins-pontos;
      atualizarUsuario(user);
    }
    
   
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
  Future<bool> redefinirCredenciais(String senha) async {
    final AuthCredential credential = EmailAuthProvider.credential(
  email: user!.email, 
  password: senha,      
);
try {
  await _auth.currentUser!.reauthenticateWithCredential(credential);
  
  debugPrint('Reautenticação bem-sucedida! Pode continuar com a operação.');
  return true;
} on FirebaseAuthException catch (e) {
  // ERRO! A senha estava incorreta ou outro problema de autenticação.
  if (e.code == 'wrong-password') {
    debugPrint('A senha digitada está incorreta.');
    return false;
  } else {
    debugPrint('Erro durante a reautenticação: ${e.message}');
     return false;
  }
} catch (e) {
  debugPrint('Erro inesperado: $e');
   return false;
}
  }

  Future<void> esqueceuSenha() async {
    await _auth.sendPasswordResetEmail(email: _user!.email);
    notifyListeners();
  }
   void atualizarNome(String nome){
      Usuario user = _user!;  
      user.nome =nome;
      atualizarUsuario(user);
    }
}
