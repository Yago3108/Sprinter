import 'package:myapp/entities/produto.dart';
import 'package:myapp/modules/produto/produto_spec.dart';

class ProdutoUseCase {
  ProdutoUseCase({required this.repository});

  final ProdutoRepository repository;

  Future<void> adicionarProduto(Produto produto) async {
    await repository.adicionarProduto(produto);
  }

  Future<void> deletarProduto(String produtoId) async {
    await repository.deletarProduto(produtoId);
  }

  Future<List<Produto>> carregarProdutos() async {
    return await repository.carregarProdutos();
  }

  Future<Produto?> carregarProduto(String id) async {
    return await repository.carregarProduto(id);
  }
}