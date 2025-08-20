import 'package:flutter/material.dart';
import 'package:myapp/util/widget_pesquisa.dart';

class PaginaProduto extends StatefulWidget {
  final String produtoId;
  const PaginaProduto(Key? key, this.produtoId) : super(key: key);

  @override
  PaginaProdutoState createState() => PaginaProdutoState();
}

class PaginaProdutoState extends State<PaginaProduto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(children: [
          WidgetPesquisa(),
          Text("")

          ],
        )
      )
    );
  }
}
