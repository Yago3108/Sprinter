import 'package:flutter/widgets.dart';
import 'package:myapp/entities/produto.dart';

class ProdutoProvider with ChangeNotifier {
  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  void addProduto(Produto produto) {
    _produtos.add(produto);
  }
}