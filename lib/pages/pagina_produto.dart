import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/util/modelo_produto.dart';
import 'package:myapp/util/produto.dart';
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
  
  int quantidade = 1;
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
  return null;}
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
  void comprar() {
    final userProvider = context.read<UserProvider>();
    final dados = userProvider.user;
    if (produto == null || dados == null) return;

  //  if ((dados.carboCoins ?? 0) < produto!.preco * quantidade) {
      // saldo insuficiente
   //   showDialog(
    //    context: context,
   //     builder: (context) => AlertDialog(
     //     title: const Text('Saldo insuficiente'),
       //   content: const Text('Você não tem pontos suficientes para esta compra.'),
         // actions: [
         //   TextButton(
         //     
         //     onPressed: () => Navigator.pop(context),
          //    child: const Text('OK'),
           // ),
         // ],
      //  ),
    //  );
   //   return;
   // }

    // mostrar carrinho
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  WidgetCarrinho(null, produto!.id, quantidade,dados!.uid, produto!.preco, produto!.nome),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
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
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: ListView(
          children:[Column(
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
              Padding(padding: EdgeInsetsGeometry.only(top: 15)),
              if (produto != null) Image.memory(
                      imagemBytes!,
                      height: 250,
                      width: 350,
                      fit: BoxFit.cover,
                    ) else SizedBox(
                      height: 250,
                      width: 300,
                      child: Center(child: Icon(Icons.image, size: 50)),
          
                    ),
              Padding(padding: EdgeInsetsGeometry.only(top: 15)),
                    Text(produto?.nome ?? 'Carregando...',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  )),
              Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                    Row(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(" ${produto?.preco.toStringAsFixed(0) ?? ''} ",
                                        style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Medula One',
                        color: Color.fromARGB(255, 29, 64, 26),
                                        )),
                        Text(" Cc",
                        style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'League Spartan',
                        color: Color.fromARGB(255, 29, 64, 26),
                                        )),
                      ],
                    ),
              Padding(padding: EdgeInsetsGeometry.only(top: 15)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                       color: Color.fromARGB(255, 168, 168, 168),
                ),
                width: 330,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding:  EdgeInsetsGeometry.only(left: 10)),
                    Text("Quantidade: ",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'League Spartan',
                      color: Color.fromARGB(255, 29, 64, 26),
                    ),),
                   Padding(padding: EdgeInsetsGeometry.only(left: 5)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                               quantidade--;
                        if (quantidade < 1) quantidade = 1;
                        });
                      },
                      icon: Icon(Icons.remove,
                      size: 30,
                      color: Color.fromARGB(255, 29, 64, 26),
                      ),
                    ),
                    Text(quantidade.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'League Spartan',
                      color: Color.fromARGB(255, 29, 64, 26),)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                             quantidade++;
                        });
                      },
                      icon: Icon(Icons.add,
                      size: 30,
                      color: Color.fromARGB(255, 29, 64, 26),
                      ),),
                   
                  ],
                ),
              ),
              Padding(padding: EdgeInsetsGeometry.only(top: 15)),
              TextButton(
                onPressed: (){
                  comprar();
              }, child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: Color.fromARGB(255, 5, 106, 12),
                ),
                child: Text("COMPRAR",style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Lao Muang Don',
                  color: Colors.white,
                ),),
              )),
              Padding(padding:  EdgeInsetsGeometry.only(top: 15)),
              Text("Descrição:",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  )),
              Container(
                height:5,
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 5, 106, 12),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                    Text(produto?.descricao ?? 'Carregando...',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                  )),
                Padding(padding:  EdgeInsetsGeometry.only(top: 15)),
              Text("Outros produtos:",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'League Spartan',
                    color: Color.fromARGB(255, 29, 64, 26),
                    
                  )),
              Container(
                height:5,
                width: 100,
                decoration: BoxDecoration(
                      color: Color.fromARGB(255, 5, 106, 12),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
                  Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                SizedBox(
                  height: 380,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ProdutoCard(produtoId: "p139gzs4M5MTjmLd6AcO"),
                      ProdutoCard(produtoId: "p139gzs4M5MTjmLd6AcO"),
                      ProdutoCard(produtoId: "p139gzs4M5MTjmLd6AcO"),
                    ],
                  ),
                ),
                 Padding(padding: EdgeInsetsGeometry.only(top: 5)),
            ],
          ),
          ] ,
        ),
      ),
    );
  }

}
