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
  List<String> listaDeProdutos=[
    "f80gFP9HAIo5woMkUFFY",
    "W7ypyI5wvzlvw1FjE4q4",
    "Rg3UsIfL6mCWI1u6Ymhb"
  ];
  void _mostrarPesquisa(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: _removerPesquisa,
          child: Material(
            color: const Color.fromARGB(85, 0, 0, 0),
            
             // fundo semitransparente
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 85, left: 16, right: 16),
                  padding: const EdgeInsets.all(8),
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
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
  void _removerPesquisa() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  @override
  void initState() {
    super.initState();
  
  }
  @override
  Widget build(BuildContext context) {
    final maisVendidos = context.watch<ProdutoProvider>().produtos;

    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        Padding(padding: EdgeInsetsGeometry.only(left: 140)),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text("Destaques:",style: TextStyle(
                  fontSize: 20,
                  fontFamily: "League Spartan"
                ),),
                Padding(padding: EdgeInsets.only(top: 10)),
                CarouselSlider.builder(
               itemCount: listaDeProdutos.length,
               itemBuilder: (context, index, realIndex) {
               final produto = listaDeProdutos[index];
               return ProdutoCarrossel(produtoId: produto,    width: 250,
            height: 250,); 
            },
         options: CarouselOptions(
        height: 305.0,
        autoPlay: true, 
        enlargeCenterPage: true, 
        aspectRatio: 16/9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true, 
        viewportFraction: 0.7,
      ),
    ),
                Padding(padding: EdgeInsets.only(top: 10)),
                  Text("Mais vendidos",style: TextStyle(
                  fontSize: 20,
                  fontFamily: "League Spartan"
                ),),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  height: 5,
                  width: 100,
                  color: Color.fromARGB(255, 5, 106, 12),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  height: 380,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: maisVendidos.length,
                    itemBuilder: (context, index) {
                      final maisVendido = maisVendidos[index];
                      return ProdutoCard(produtoId: maisVendido.id);
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
