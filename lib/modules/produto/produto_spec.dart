import 'package:myapp/entities/produto.dart';

abstract class ProdutoRepository {
  Future<void> adicionarProduto(Produto produto);
  Future<void> deletarProduto(String id);
  Future<List<Produto>> carregarProdutos();
  Future<Produto?> carregarProduto(String id);
}