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
    final estatisticaProvider=context.watch<EstatisticaProvider>();
    final userProvider=context.watch<UserProvider>();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
                Padding(padding: EdgeInsetsGeometry.only(top: 15)),
            Row(
              children: [
                Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                IconButton(onPressed: (){
                    estatisticaProvider.carregarAtividades(userProvider.user!.uid);
                }, icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: Icon(Icons.replay_outlined,color: Colors.white,),
                )),
                Padding(padding: EdgeInsetsGeometry.only(right: 10)),
                Text("Recarregar estatísticas",style: TextStyle(
                  fontFamily: "League Spartan",
                  fontSize: 18,
                ),)
              ],
            ),
            Padding(padding: EdgeInsetsGeometry.only(top: 15)),
            Container(
              height: 300,
              width: 350,
              decoration: BoxDecoration(
                border: BoxBorder.all(
                  color: Color.fromARGB(255, 5, 106, 12),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(35),
              
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsetsGeometry.only(top: 5)),
                  Row(
                    children: [
                       Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                      Text("Distância percorrida",style: TextStyle(
                        fontFamily: "League Spartan",
                        fontSize: 15,
                      ),),
                      Padding(padding: EdgeInsetsGeometry.only(left: 40)),
                        Container(
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
                    ],
                  ),
              SizedBox(
                   height: 240,
             
              child: TabBarView(
                controller: _tabController,
                children: [
                  //semanal
                    Center(child: GraficoHistorico(periodo: Periodo.semana,)),
                    //mensal
                    Center(child: GraficoHistorico(periodo: Periodo.mes,)),
                    //anual
                    Center(child: GraficoHistorico(periodo: Periodo.ano,)),
                ],
              ),
              )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}