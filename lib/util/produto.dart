import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String tipo;
  final String imagemBase64;
  final int quantidade;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.tipo,
    required this.imagemBase64,
    required this.quantidade,
  });

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
