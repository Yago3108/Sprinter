import 'package:cloud_firestore/cloud_firestore.dart';

// model de produto
class Produto {

  // variáveis de produto
  final String? id;
  final String nome;
  final String descricao;
  final double preco;
  final String tipo;
  final String imagemBase64;
  final int quantidade;

  // construtor
  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.tipo,
    required this.imagemBase64,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'tipo': tipo,
      'imagemBase64': imagemBase64,
      'quantidade': quantidade,
    };
  }

  // transforma map em produto
  factory Produto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Produto(
      nome: data['nome'],
      id: doc.id,
      descricao: data['descricao'],
      preco: data['preco'],
      tipo: data['tipo'],
      imagemBase64: data['imagem'],
      quantidade: data['quantidade'],
    );
  }
}
