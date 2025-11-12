import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/infrastructure/presentation/widgets/grafico.dart';
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
                final user = userProvider.user;
     final estatisticaProvider = context.read<EstatisticaProvider>();
        estatisticaProvider.carregarAtividades(userProvider.user!.uid);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
              
               
    
          Padding(padding: EdgeInsets.only(top:15)),
                  
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
                      
                    Padding(padding: EdgeInsets.only(top: 30)),
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
                      
                    Padding(padding: EdgeInsets.only(top: 30)),
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
            ]
          ),
        ),
      ),
    );
  }
}