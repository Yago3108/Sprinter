import 'package:flutter/material.dart';
import 'package:myapp/util/widget_pesquisa.dart';

class PaginaProduto extends StatefulWidget {
  final String produtoId;
  const PaginaProduto(Key? key, this.produtoId) : super(key: key);

  @override
  PaginaProdutoState createState() => PaginaProdutoState();
}

class PaginaProdutoState extends State<PaginaProduto> {
  OverlayEntry? _overlayEntry;
  void _mostrarPesquisa(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Material(
          color: Colors.black.withOpacity(0.5), // fundo semitransparente
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60, left: 16, right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // seu widget de pesquisa importado
                    WidgetPesquisa(
                      onProdutoSelecionado: (produtoId) {
                      // remove overlay
                      _removerPesquisa();

                      // navega para a página de produto
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaginaProduto(null, produtoId),
                        ),
                      );
                    }
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
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removerPesquisa() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Color.fromARGB(255, 5, 106, 12),
                  width: 2.0,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  _mostrarPesquisa(context);
                },
                icon: Row(
                  children: [
                    Text("Ingresso para..."),
                    Padding(padding: EdgeInsetsGeometry.only(left: 150)),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsetsGeometry.only(top: 15)),
            Text(""),
          ],
        ),
      ),
    );
  }
}
