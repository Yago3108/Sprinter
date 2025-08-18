import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> continuarComGoogle() async {
    try {
      // 1. Iniciar o processo de login com o Google
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // O usuário cancelou o login
        return;
      }

      // 2. Autenticar com o Firebase usando as credenciais do Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // 3. Verificar se o usuário já existe no Firestore
        final DocumentSnapshot userDoc =
            await _firestore.collection('usuarios').doc(user.uid).get();

        if (!userDoc.exists) {
          // Se o usuário não existe, crie um novo documento no Firestore
          final novoUsuario = Usuario(
            uid: user.uid,
            nome: user.displayName ?? '',
            email: user.email ?? '',
            cpf: "",
            nascimento: "",
            carboCoins: 0.0,
            carbono: 0.0,
            distancia: 0.0,
            fotoPerfil: user.photoURL ?? '', // Use a foto do perfil do Google
          );

          // Converta o objeto para um mapa e salve no Firestore
          await _firestore
              .collection('usuarios')
              .doc(novoUsuario.uid)
              .set(novoUsuario.toMap());

          print('Novo usuário criado e salvo no Firestore!');
        } else {
          print('Usuário já existe no Firestore.');
        }
      }
    } catch (e) {
      print('Erro durante o login com o Google: $e');
      // Você pode mostrar uma mensagem de erro para o usuário aqui
    }
    notifyListeners();
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
