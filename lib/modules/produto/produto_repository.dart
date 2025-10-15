import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/entities/produto.dart';
import 'package:myapp/modules/produto/produto_spec.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> adicionarProduto(Produto produto) async {
    try {
      await _firestore.collection('produtos').doc(produto.id).set(produto.toMap());
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }

  @override
  Future<void> deletarProduto(String produtoId) async {
    try {
      await _firestore.collection('produtos').doc(produtoId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  @override
  Future<List<Produto>> carregarProdutos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('produtos').get();
      List<Produto> produtos = snapshot.docs.map((doc) {
        return Produto.fromFirestore(doc.data());
      }).toList();
      return produtos;
    } catch (e) {
      throw Exception("Erro ao carregar produtos: $e");
    }
  }

  @override
  Future<Produto?> carregarProduto(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('produtos').doc(id).get();
      if (doc.exists) {
        return Produto.fromFirestore();
      }
      return null;
    } catch (e) {
      throw Exception("Erro ao carregar produto: $e");
    }
  }
}