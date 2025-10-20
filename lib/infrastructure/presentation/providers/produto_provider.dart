import 'dart:convert';
import 'dart:io';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:provider/provider.dart';
import '../../../entities/produto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdutoProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int qtdCompra = 1;

  // Produto carregado
  Produto? _produto;

  // Lista de produtos carregados
  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  // Adicionar produto no Firestore
  Future<void> adicionarProduto(
    String nome,
    String descricao,
    int preco,
    String tipo,
    File imagem,
    int quantidade,
  ) async {
    try {
      List<int> imageBytes = await imagem.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      DocumentReference docRef = await _firestore.collection('produtos').add({
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'tipo': tipo,
        'imagemBase64': base64Image,
        'quantidade': quantidade,
      });

      // Atualiza a lista local
      _produtos.add(Produto(
        id: docRef.id,
        nome: nome,
        descricao: descricao,
        preco: preco,
        tipo: tipo,
        imagemBase64: base64Image,
        quantidade: quantidade,
      ));

      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }

  // Deletar produto
  Future<void> deletarProduto(String produtoId) async {
    try {
      await _firestore.collection('produtos').doc(produtoId).delete();
      _produtos.removeWhere((p) => p.id == produtoId);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  // Atualizar o produto no banco de dados
  Future<void> atualizarProduto(Produto novoProduto) async {
    await _firestore
        .collection('produtos')
        .doc(novoProduto.id)
        .update(novoProduto.toMap());

    _produto = novoProduto;
    notifyListeners();
  }

  // Carregar todos os produtos
  Future<List<Produto>> carregarProdutos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('produtos').get();
      _produtos =
          snapshot.docs.map((doc) => Produto.fromFirestore(doc)).toList();
      notifyListeners();
      return _produtos;
    } catch (e) {
      throw Exception("Erro ao carregar produtos: $e");
    }
  }

  // Carregar apenas 1 produto pelo ID
  Future<Produto?> carregarProduto(String id) async {
    try {
      final doc = await _firestore.collection('produtos').doc(id).get();
      if (doc.exists) {
        final data=doc.data();
        _produto = Produto(
          descricao: data!["descricao"],
          id: id,
          nome: data["nome"],
          imagemBase64: data["imagemBase64"],
          preco: data["preco"].round(),
          quantidade: data["quantidade"],
          tipo: data["tipo"]
        );
        Produto prod=Produto(
          descricao: data!["descricao"],
          id: id,
          nome: data["nome"],
          imagemBase64: data["imagemBase64"],
          preco: data["preco"].round(),
          quantidade: data["quantidade"],
          tipo: data["tipo"]
        );
        return prod;
      }
      return null;
    } catch (e) {
      throw Exception("Erro ao carregar produto: $e");
    }
  }

  //Aumentar quantidade comprada
  void incrementar(Produto pro) {
    if (qtdCompra < pro.quantidade) {
      qtdCompra++;
      notifyListeners();
    }
  }

  //Diminuar quantidade comprada
  void decrementar() {
    if (qtdCompra > 1) {
      qtdCompra--;
      notifyListeners();
    }
  }

  //Atualizar quantidade do produto
  void atualizarQtdProd(int qtdCompra){
    Produto produto = _produto!;
    produto.quantidade = produto.quantidade - qtdCompra;
    atualizarProduto(produto);
  }

  //Reseta a quantidade comprada
  void resetar() {
    qtdCompra = 1;
    notifyListeners();
  }

  
}
