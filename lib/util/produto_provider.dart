import 'dart:convert';
import 'dart:io';
import '../util/produto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdutoProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Produto> _produtos = [];

  List<Produto> get produtos => _produtos;

  Future<void> adicionarProduto(
    String nome,
    String descricao,
    double preco,
    String tipo,
    File imagem,
    int quantidade,
  ) async {
    try {
      
           // 1. Ler bytes da imagem
      List<int> imageBytes = await imagem.readAsBytes();

      // 2. Converter para base64
      String base64Image = base64Encode(imageBytes);
      await _firestore.collection('produtos').add({
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'tipo': tipo,
        'imagem': base64Image,
        'quantidade': quantidade
      });
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }

 
  Future<void> deletarProduto(String nome) async {
    try {
      await _firestore.collection('produtos').doc(nome).delete();
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }
  
  Future<void> carregarProdutos() async {
  try {
    QuerySnapshot snapshot = await _firestore.collection('produtos').get();
    _produtos = snapshot.docs.map((doc) => Produto.fromFirestore(doc)).toList();
    notifyListeners();
  } catch (e) {
    throw Exception("Erro ao carregar produtos: $e");
  }
}
}