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
bool _dataLoaded = false;
  @override
  void initState() {
    super.initState();
    // Criando o TabController com 3 abas
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataLoaded) {
      final userProvider = context.read<UserProvider>();
      final estatisticaProvider = context.read<EstatisticaProvider>();
      if (userProvider.user != null) {
        estatisticaProvider.carregarAtividades(userProvider.user!.uid);
        _dataLoaded = true;
      }
    }
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
     final estatisticaProvider = context.watch<EstatisticaProvider>();
        estatisticaProvider.carregarAtividades(userProvider.user!.uid);
        if (_dataLoaded && estatisticaProvider.semanas.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
                  Padding(padding: EdgeInsetsGeometry.only(top: 40)),
        
        
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                                 Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF056A0C),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                           Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Seu Rendimento",style: TextStyle(
                              fontFamily: "League Spartan",
                              fontSize:25 ,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                      ],
                      ),
                    ),
            
                      Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                     height: 240,
               
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    //semanal
                      Center(child: Column(
                        children: [
                     
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Semanal",style: TextStyle(
                            fontFamily: "League Spartan",
                            fontSize: 20,
                            color: Color.fromARGB(255, 5, 106, 12),
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                  
                    Padding(padding: 
                    EdgeInsetsGeometry.only(top: 10)),
                          Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GraficoHistorico(periodo: Periodo.semana,dataReferencia: DateTime.now()),
                          ),
                        ],
                      )),
                      //mensal
                      Center(child: Column(
                        children: [
                        
                   Text("Mensal",style: TextStyle(
                            fontFamily: "League Spartan",
                            fontSize: 20,
                            color: Color.fromARGB(255, 5, 106, 12),
                            fontWeight: FontWeight.bold,
                          ),),
                  
                    Padding(padding: 
                    EdgeInsetsGeometry.only(top: 10)),
                          Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GraficoHistorico(periodo: Periodo.mes,dataReferencia: DateTime.now()),
                          ),
                        ],
                      )),
                      //anual
                      Center(child: Column(
                        children: [
                          
                    Text("Anual",style: TextStyle(
                            fontFamily: "League Spartan",
                            fontSize: 20,
                            color: Color.fromARGB(255, 5, 106, 12),
                            fontWeight: FontWeight.bold,
                          ),),
                    
                    Padding(padding: 
                    EdgeInsetsGeometry.only(top: 10)),
                          Padding(
        
                                 padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GraficoHistorico(periodo: Periodo.ano,dataReferencia: DateTime.now()),
                          ),
                        ],
                      )),
                  ],
                ),
                ),
                          Padding(padding: EdgeInsets.only(top:5)),
                      Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: TabBar(
                                    dividerColor: const Color.fromARGB(0, 255, 255, 255),
                                    controller: _tabController,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                                  indicator: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: const Color.fromARGB(95, 49, 88, 58),
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
                     Padding(padding: EdgeInsets.only(top: 10)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                                              padding: const EdgeInsets.all(25),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                            Color.fromARGB(255, 19, 75, 22),
                            Color.fromARGB(255, 136, 170, 139),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(24),
                                                boxShadow: [
                                                  BoxShadow(
                            color: const Color(0xFF056A0C).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  Text(
                            "CO2 economizado",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lao Muang Don',
        
                            ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                            "${user!.carbono.toStringAsFixed(2)} ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'League Spartan',
                              letterSpacing: -1,
                            ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Continue deixando de emitir CO2",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontFamily: 'Lao Muang Don',
                                ),
                              ),
                            ],
                                                  ),
                                                ],
                                              ),
                                            ),
                          ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                                              padding: const EdgeInsets.all(25),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                            Color.fromARGB(255, 19, 75, 22),
                            Color.fromARGB(255, 136, 170, 139),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(24),
                                                boxShadow: [
                                                  BoxShadow(
                            color: const Color(0xFF056A0C).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  Text(
                            "Distância Percorrida",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lao Muang Don',
        
                            ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                            "${user.distancia.toStringAsFixed(1)} km",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'League Spartan',
                              letterSpacing: -1,
                            ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Continue se exercitando!",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontFamily: 'Lao Muang Don',
                                ),
                              ),
                            ],
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