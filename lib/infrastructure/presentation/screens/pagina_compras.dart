import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/widgets/produto_carrossel.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_produto.dart';
import 'package:myapp/infrastructure/presentation/widgets/modelo_produto.dart';
import 'package:myapp/infrastructure/presentation/widgets/widget_pesquisa.dart';
import 'package:provider/provider.dart';

class PaginaCompras extends StatefulWidget {
  const PaginaCompras({super.key});

  @override
  PaginaComprasState createState() => PaginaComprasState();
}

class PaginaComprasState extends State<PaginaCompras> {
  OverlayEntry? _overlayEntry;

  final List<String> listaDeProdutos = [
    "f80gFP9HAIo5woMkUFFY",
    "W7ypyI5wvzlvw1FjE4q4",
    "Rg3UsIfL6mCWI1u6Ymhb",
  ];

  @override
  void dispose() {
    _removerPesquisa();
    super.dispose();
  }

  void _mostrarPesquisa(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: _removerPesquisa,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Material(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 100,
                      left: 20,
                      right: 20,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Buscar Produtos",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a1a1a),
                                fontFamily: 'League Spartan',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 24),
                              onPressed: _removerPesquisa,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                      ],
                    ),
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    final maisVendidos = context.watch<ProdutoProvider>().produtos;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Compras",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'League Spartan',
                ),
              ),
          
              const SizedBox(height: 20),
          
              GestureDetector(
                onTap: () => _mostrarPesquisa(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], size: 24),
                      const SizedBox(width: 12),
                      Text(
                        "Buscar produtos...",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 30),
          
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF056A0C),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Destaques",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a1a),
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ],
              ),
              
          
              const SizedBox(height: 10),
          
              CarouselSlider.builder(
                itemCount: listaDeProdutos.length,
                itemBuilder: (context, index, realIndex) {
                  final produto = listaDeProdutos[index];
                  return ProdutoCarrossel(
                    produtoId: produto,
                    width: 250,
                    height: 250,
                  );
                },
                options: CarouselOptions(
                  height: 320.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.easeInOutCubic,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enableInfiniteScroll: true,
                  viewportFraction: 0.75,
                ),
              ),
          
              const SizedBox(height: 10),
          
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF056A0C),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Mais Vendidos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1a1a1a),
                            fontFamily: 'League Spartan',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF056A0C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.whatshot,
                            color: Color(0xFF056A0C),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Top ${maisVendidos.length}",
                            style: const TextStyle(
                              color: Color(0xFF056A0C),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lao Muang Don',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          
              const SizedBox(height: 10),
          
              SizedBox(
                height: 400,
                child: maisVendidos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Nenhum produto disponível",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'Lao Muang Don',
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: maisVendidos.length,
                        itemBuilder: (context, index) {
                          final maisVendido = maisVendidos[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < maisVendidos.length - 1 ? 16 : 0,
                            ),
                            child: ProdutoCard(produtoId: maisVendido.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
