import 'package:myapp/entities/produto.dart';

abstract class IProdutoUseCases {
  String? validarNome(String nome);

  String? validarDescricao(String descricao);

  String? validarPreco(String preco);

  String? validarTipo(String tipo);

  String? validarQuantidade(String quantidade);

  String? validarImagem(String imagem);

  Future<void> cadastrarProduto(String nome, String descricao, String preco, String tipo, String quantidade, String imagem);
}