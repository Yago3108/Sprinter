import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/entities/produto.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart';
import 'package:provider/provider.dart';
import 'modelo_produto.dart';

class ListProdutos extends StatefulWidget {
  const ListProdutos({super.key});

  @override
  _ListProdutosState createState() => _ListProdutosState();
}

class _ListProdutosState extends State<ListProdutos> {
  Future<String?> pegarIdProdutoPorNome(String nome) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('produtos')
          .where('nome', isEqualTo: nome)
          .limit(1) // só precisa do primeiro
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // não encontrou produto
      }

      final doc = querySnapshot.docs.first;
      return doc.id; // retorna o UID do produto
    } catch (e) {
      print("Erro ao buscar ID do produto: $e");
      return null;
    }
  }

  void initState() {
    super.initState();
    context.read<ProdutoProvider>().carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProdutoProvider>();

    return FutureBuilder<List<Produto>>(
      future: provider.carregarProdutos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Nenhum produto encontrado"));
        }

        final produtos = snapshot.data!;
        return ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            return ProdutoCard(produtoId: produto.id);
          },
        );
      },
    );
  }
}
