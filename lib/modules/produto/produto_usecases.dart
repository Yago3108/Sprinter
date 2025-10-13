import 'package:myapp/entities/produto.dart';
import 'package:myapp/modules/produto/produto_repository.dart';
import 'package:myapp/modules/produto/produto_spec.dart';

class ProdutoUseCases implements IProdutoUseCases {
  final ProdutoRepository produtoRepository = ProdutoRepository();

  @override
  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode ser vazio" : null;

  @override
  String? validarDescricao(String descricao) => descricao.isEmpty ? "Descrição não pode ser vazia" : null;

  @override
  String? validarPreco(String preco) {
    if(preco.isEmpty) {
      return "Preço não pode estar vazio";
    } else if(RegExp(r'^\d*$').hasMatch(preco)) {
      return "Preço tem que conter apenas números";
    }

    return null;
  }

  @override
  String? validarTipo(String tipo) => tipo.isEmpty ? "Tipo não pode ser vazio" : null;
  
  @override
  String? validarQuantidade(String quantidade) {
    if(quantidade.isEmpty) {
      return "Quantidade não pode estar vazio";
    } else if(RegExp(r'^\d*$').hasMatch(quantidade)) {
      return "Quantidade tem que conter apenas números";
    }

    return null;
  }

  @override
  String? validarImagem(String imagem) => imagem.isEmpty ? "Tipo não pode ser vazio" : null;

  Future<String?> cadastrarProduto(String nome, String descricao, String preco, String tipo, String quantidade, String imagem) async {
    try {
      Produto produto = Produto(nome: nome, descricao: descricao, preco: double.parse(preco), tipo: tipo, imagemBase64: imagem, quantidade: int.parse(quantidade));
      await produtoRepository.adicionarProduto(produto);
      return null;
    } catch(e) {
      return "Erro no Cadastro";
    }
  }
}