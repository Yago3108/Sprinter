import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/infrastructure/presentation/app/components/grafico.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PaginaRendimento extends StatefulWidget {
  const PaginaRendimento({super.key});

  @override
  State<PaginaRendimento> createState() => _PaginaRendimentoState();
}

class _PaginaRendimentoState extends State<PaginaRendimento> 
   with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Criando o TabController com 3 abas
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
              final userProvider = context.read<UserProvider>();
     final estatisticaProvider = context.read<EstatisticaProvider>();
        estatisticaProvider.carregarAtividades(userProvider.user!.uid);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
                Padding(padding: EdgeInsetsGeometry.only(top: 40)),
      
      
                  Row(
                    children: [
                       Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Distância percorrida",style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: 25,
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                  ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                                width: 150,
                                child: TabBar(
                                  dividerColor: Colors.white,
                                  controller: _tabController,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                                indicator: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: const Color.fromARGB(96, 139, 195, 74),
                                                  borderRadius:BorderRadius.circular(15)
                                                ),
                                                labelColor: Colors.white,
                                                unselectedLabelColor: Colors.black,
                                                indicatorColor: Color.fromARGB(255, 0, 128, 0),
                                             
                                                tabs: [
                                                  Tab(text: 'S'),
                                                  Tab(text: "M"),
                                                  Tab(text: 'A'),
                                                ],
                                              ),
                              ),
                      ),
                    ],
                  ),
             
              SizedBox(
                   height: 240,
             
              child: TabBarView(
                controller: _tabController,
                children: [
                  //semanal
                    Center(child: Column(
                      children: [
                      Row(
                    children: [
                       Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Semanal",style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: 20,
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                  ],
                  ),
                  Padding(padding: 
                  EdgeInsetsGeometry.only(top: 10)),
                        Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(103, 107, 168, 111),
                               spreadRadius: 5, 
                                blurRadius: 7, 
                                offset: Offset(0, 3), 
                                )
                              ]
                            ),
                            child: GraficoHistorico(periodo: Periodo.semana,dataReferencia: DateTime.now())),
                        ),
                      ],
                    )),
                    //mensal
                    Center(child: Column(
                      children: [
                           Row(
                    children: [
                       Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Mensal",style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: 20,
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                  ],
                  ),
                  Padding(padding: 
                  EdgeInsetsGeometry.only(top: 10)),
                        Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(103, 107, 168, 111),
                               spreadRadius: 5, 
                                blurRadius: 7, 
                                offset: Offset(0, 3), 
                                )
                              ]
                            ),
                            child: GraficoHistorico(periodo: Periodo.mes,dataReferencia: DateTime.now())),
                        ),
                      ],
                    )),
                    //anual
                    Center(child: Column(
                      children: [
                        
                  Row(
                    children: [
                       Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Anual",style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: 20,
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                  ],
                  ),
                  Padding(padding: 
                  EdgeInsetsGeometry.only(top: 10)),
                        Padding(

                               padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(103, 107, 168, 111),
                               spreadRadius: 5, 
                                blurRadius: 7, 
                                offset: Offset(0, 3), 
                                )
                              ]
                            ),
                            child: GraficoHistorico(periodo: Periodo.ano,dataReferencia: DateTime.now())),
                        ),
                      ],
                    )),
                ],
              ),
              )
        
          ],
        ),
      ),
    );
  }
}