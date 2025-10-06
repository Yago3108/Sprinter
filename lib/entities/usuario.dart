// model de usuário
class Usuario {

  // variáveis
  final List<Usuario> amigos; 
  final String uid;
  final String nome;
  final String email;
  final String cpf;
  final String nascimento;
  int carboCoins;
  double carbono;
  double distancia;
  dynamic fotoPerfil;

  // construtor
  Usuario({
    required this.amigos,
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

  // transforma map em usuário
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      amigos: [],
      uid: map['uid'],
      nome: map['nome'],
      email: map['email'],
      cpf: map['cpf'],
      nascimento: map['nascimento'],
      carboCoins: (map['carboCoins'] ?? 0),
      carbono: (map['carbono'] ?? 0).toDouble(),
      distancia: (map['distancia'] ?? 0).toDouble(),
      fotoPerfil: map['Foto_perfil'],
    );
  }

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
}
