import 'package:flutter/material.dart';
import 'package:myapp/util/produto.dart';
import 'package:myapp/util/produto_provider.dart';
import 'package:provider/provider.dart';
import '../util//modelo_produto.dart';

class ListProdutos extends StatefulWidget {
  ListProdutos({Key? key}) : super(key: key);

  @override
  _ListProdutosState createState() => _ListProdutosState();
}

class _ListProdutosState extends State<ListProdutos> {
  void initState() {
    super.initState();
    context.read<ProdutoProvider>().carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    List<Produto> produtos = context.watch<ProdutoProvider>().produtos;
    return produtos.isEmpty
        ? CircularProgressIndicator()
        : ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            return ProdutoCard(produtoId: produto.nome);
          },
        );
  }
}
