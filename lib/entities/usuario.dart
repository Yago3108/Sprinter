// model de usuário
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {

  // variáveis
  final String? uid;
  final String nome;
  final String cpf;
  final String nascimento;
  final String email;
  final int? carboCoins;
  final double? carbono;
  final double? distancia;
  final dynamic fotoPerfil;
  final List<Usuario>? amigos; 

  // construtor
  Usuario({
    this.uid,
    required this.nome,
    required this.cpf,
    required this.nascimento,
    required this.email,
    this.carboCoins,
    this.carbono,
    this.distancia,
    this.fotoPerfil,
    this.amigos,  
  });

  // transforma usuário em map
  Map<String, dynamic> toMap() {
    return {
      'amigos': amigos,
      'uid': uid,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'nascimento': nascimento,
      'carboCoins': carboCoins,
      'carbono': carbono,
      'distancia': distancia,
      'Foto_perfil': fotoPerfil,
    };
  }

  factory Usuario.fromMap(Map <String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      nome: map['nome'], 
      cpf: map['cpf'], 
      nascimento: map['nascimento'], 
      email: map['email'],
      carboCoins: map['carboCoins'],
      carbono: map['carbono'],
      distancia: map['distancia'],
      fotoPerfil: map['fotoPerfil'],
    );
  }

  factory Usuario.fromFirebaseUser(DocumentSnapshot doc) {
    return Usuario(
      uid: doc['uid'],
      nome: doc['nome'],
      cpf: doc['cpf'],
      nascimento: doc['nascimento'],
      email: doc['email'],
      carboCoins: doc['carboCoins'],
      carbono: doc['carbono'],
      distancia: doc['distancia'],
      fotoPerfil: doc['fotoPerfil'],
    );
  }
}
