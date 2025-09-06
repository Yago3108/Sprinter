class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String cpf;
  final String nascimento;
  final double carboCoins;
  final double carbono;
  final double distancia;
  dynamic fotoPerfil;

  Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.nascimento,
    required this.carboCoins,
    required this.carbono,
    required this.distancia,
    this.fotoPerfil,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      nome: map['nome'],
      email: map['email'],
      cpf: map['cpf'],
      nascimento: map['nascimento'],
      carboCoins: (map['carboCoins'] ?? 0).toDouble(),
      carbono: (map['carbono'] ?? 0).toDouble(),
      distancia: (map['distancia'] ?? 0).toDouble(),
      fotoPerfil: map['Foto_perfil'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
}
