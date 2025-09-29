import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/util/modelo_produto.dart';
import 'package:myapp/util/produto.dart';
import 'package:myapp/util/produto_provider.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:myapp/util/widget_carrinho.dart';
import 'package:myapp/util/widget_pesquisa.dart';
import 'package:provider/provider.dart';

class PaginaProduto extends StatefulWidget {
  final String produtoId;
  const PaginaProduto(Key? key, this.produtoId) : super(key: key);

  @override
  PaginaProdutoState createState() => PaginaProdutoState();
}

class PaginaProdutoState extends State<PaginaProduto> {

  
  OverlayEntry? _overlayEntry;
  Uint8List? imagemBytes;
  Produto? produto;

  Future<Produto?> buscarProdutoPorId(String produtoId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('produtos')
          .doc(produtoId)
          .get();

      if (doc.exists) {
        return Produto.fromFirestore(doc);
      }
    } catch (e) {
      print('Erro ao buscar produto: $e');
      return null;
    }
    return null;
  }

  void _mostrarPesquisa(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: _removerPesquisa,
          child: Material(
            color: const Color.fromARGB(85, 0, 0, 0),
          
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 85, left: 16, right: 16),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [

                      WidgetPesquisa(
                        onProdutoSelecionado: (produtoId) {
                          _removerPesquisa();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaginaProduto(null, produtoId),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _removerPesquisa,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removerPesquisa() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void comprar() {
    final userProvider = context.read<UserProvider>();
    final quantidade = context.read<ProdutoProvider>().qtdCompra;
    final dados = userProvider.user;

    if (produto == null || dados == null) return;

    if (dados.carboCoins < produto!.preco * quantidade) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Saldo insuficiente'),
          content: const Text('Você não tem pontos suficientes para esta compra.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: WidgetCarrinho(
          null,
          produto!.id,
          quantidade,
          dados.uid,
          produto!.preco,
          produto!.nome,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<ProdutoProvider>().resetar();
    });
    buscarProdutoPorId(widget.produtoId).then((prod) {
      setState(() {
        produto = prod;
        if (produto != null) {
          try {
            imagemBytes = base64Decode(produto!.imagemBase64);
          } catch (_) {}
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final dados = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        backgroundColor: const Color.fromARGB(255, 5, 106, 12),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: const Color.fromARGB(255, 5, 106, 12),
                      width: 2.0,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _mostrarPesquisa(context);
                    },
                    icon: Row(
                      children: const [
                        Text("Ingresso para..."),
                        Spacer(),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                if (produto != null)
                  Image.memory(
                    imagemBytes!,
                    height: 250,
                    width: 350,
                    fit: BoxFit.cover,
                  )
                else
                  const SizedBox(
                    height: 250,
                    width: 300,
                    child: Center(child: Icon(Icons.image, size: 50)),
                  ),
                const SizedBox(height: 15),
                Text(
                  produto?.nome ?? 'Carregando...',
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      " ${produto?.preco.toStringAsFixed(0) ?? ''} ",
                      style: const TextStyle(
                        fontSize: 50,
                        fontFamily: 'Medula One',
                        color: Color.fromARGB(255, 29, 64, 26),
                      ),
                    ),
                    const Text(
                      " Cc",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'League Spartan',
                        color: Color.fromARGB(255, 29, 64, 26),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Consumer<ProdutoProvider>(
                  builder: (context, quantidadeProv, _) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: const Color.fromARGB(255, 168, 168, 168),
                      ),
                      width: 330,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Quantidade: ",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'League Spartan',
                              color: Color.fromARGB(255, 29, 64, 26),
                            ),
                          ),
                          IconButton(
                            onPressed: quantidadeProv.decrementar,
                            icon: const Icon(
                              Icons.remove,
                              size: 30,
                              color: Color.fromARGB(255, 29, 64, 26),
                            ),
                          ),
                          Text(
                            quantidadeProv.qtdCompra.toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'League Spartan',
                              color: Color.fromARGB(255, 29, 64, 26),
                            ),
                          ),
                          IconButton(
                            onPressed: () => quantidadeProv.incrementar(produto!),
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                              color: Color.fromARGB(255, 29, 64, 26),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),
                TextButton(
                  onPressed: comprar,
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: const Color.fromARGB(255, 5, 106, 12),
                    ),
                    child: const Text(
                      "COMPRAR",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lao Muang Don',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                const Text(
                  "Descrição:",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  ),
                ),
                Container(
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 5, 106, 12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  produto?.descricao ?? 'Carregando...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  ),
                ),

                const SizedBox(height: 15),
                const Text(
                  "Outros produtos:",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  ),
                ),
                Container(
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 5, 106, 12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 380,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      ProdutoCard(produtoId: "p139gzs4M5MTjmLd6AcO"),
                      ProdutoCard(produtoId: "p139gzs4M5MTjmLd6AcO"),
                      ProdutoCard(produtoId: "p139gzs4M5MTjmLd6AcO"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
