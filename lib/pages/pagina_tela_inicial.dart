import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina_rendimento.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  PaginaInicialState createState() => PaginaInicialState();
}

class PaginaInicialState extends State<PaginaInicial> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final dados = userProvider.getDistanciaEPontos();
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              Image.asset("assets/images/Logo_Sprinter.png", height: 100),
              Padding(padding: EdgeInsets.only(top: 10)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaRendimento()),
                  );
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  width: 250,
                  height: 150,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Text(
                        "${dados?['distancia']}km",
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontSize: 40,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                      Text(
                        "percorridos hoje",
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontSize: 20,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsetsGeometry.only(top: 15)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaginaRendimento()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  height: 150,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Você tem:",
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontSize: 20,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                      Text(
                        "${dados?['pontos']}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontSize: 40,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                      Text(
                        "CarboCoins",
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontSize: 20,
                          fontFamily: 'Lao Muang Don',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
