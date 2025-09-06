import 'package:flutter/material.dart';

class WidgetCarrinho extends StatefulWidget {
  final String produtoId;
  final int quantidade;
  final String userId;
  final double preco;
  final String nome;

  const WidgetCarrinho(
    Key? key,
    this.produtoId,
    this.quantidade,
    this.userId,
    this.preco,
    this.nome,
  ) : super(key: key);

  @override
  _WidgetCarrinhoState createState() => _WidgetCarrinhoState();
}

class _WidgetCarrinhoState extends State<WidgetCarrinho> {
  int quantidade = 1;
  String nome = "";
  double preco = 0.0;
  String userid = "";
  String produtoid = "";
  @override
  void initState() {
    super.initState();
    quantidade = widget.quantidade;
    nome = widget.nome;
    preco = widget.preco;
    userid = widget.userId;
    produtoid = widget.produtoId;
  }

  Comprar(int quantidade, double preco, String produtoid, String userid) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 204, 204, 204),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 10,
                  color: Color.fromARGB(255, 5, 106, 12),
                ),
                Text(
                  "Carrinho",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 5, 106, 12),
                    fontFamily: "Lao Muang Don",
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text("$quantidade"),
                  Padding(padding: EdgeInsetsGeometry.only(right: 5)),
                  Text(nome),
                  Padding(padding: EdgeInsetsGeometry.only(right: 5)),
                  Text("${preco}Cc"),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 5, 106, 12),
              ),
              child: TextButton(
                child: Text(
                  "Comprar",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Lao Muang Don",
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  Comprar(quantidade, preco, produtoid, userid);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
