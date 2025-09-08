import 'package:date_format/date_format.dart';
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

  Comprar(int quantidade, double preco, String produtoid, String userid) {
    // Lógica de compra aqui
    print("Compra realizada: $quantidade x $nome por \$$preco cada.");
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 204, 204, 204),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsetsGeometry.only(right: 10)),
               Text(
                  "Carrinho:",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 5, 106, 12),
                    fontFamily: "Lao Muang Don",
                  ),
                ),
                      Padding(padding: EdgeInsetsGeometry.only(right: 110)),
                    Icon(
                  Icons.shopping_cart,
                  size: 20,
                  color: Color.fromARGB(255, 5, 106, 12),
                ),
              ],
            ),
            Padding(padding: EdgeInsetsGeometry.only(top: 20)),
            Container(
              alignment: Alignment.center,
              width: 250,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$quantidade",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 5, 106, 12),
                        fontFamily: "Lao Muang Don",
                      )),
                  Padding(padding: EdgeInsetsGeometry.only(right: 5)),
                  Text(nome,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 5, 106, 12),
                        fontFamily: "Lao Muang Don",
                      )),
                  Padding(padding: EdgeInsetsGeometry.only(right: 5)),
                ],
              ),
            ),
            Padding(padding:  EdgeInsetsGeometry.only(top: 20)),
            Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
                  Navigator.pop(context);

                  showSnackBar(BuildContext context) {
                    final snackBar = SnackBar(
                      backgroundColor: Color.fromARGB(255, 5, 106, 12),
                      content: Text("Compra realizada: $quantidade x $nome por $preco Cc.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Lao Muang Don",
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  showSnackBar( context);
                },
              ),
            ),
              Padding(padding:  EdgeInsetsGeometry.only(top: 20)),
          ],
        ),
      ),
    );
  }
}
