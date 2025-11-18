

import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/bottom_navigator_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/widgets/container_tela_inicial.dart';
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

    // Tela de carregamento caso o usuário não esteja carregado ainda
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user=userProvider.user;
   
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF056A0C)),
              ),
              const SizedBox(height: 16),
              Text(
                "Carregando...",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontFamily: 'Lao Muang Don',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Primeiro Container
              ContainerTelaInicial(
                function: () =>  context.read<BottomNavigatorProvider>().index = 3, 
                color1: Color(0xFF056A0C), 
                color2: Color(0xFF078A10),
                icon: Icons.directions_run, 
                titulo: "Distância Percorrida", 
                informacao: "${user.distancia.toStringAsFixed(1)} km", 
                mensagem: "Continue se exercitando!",
              ),

              const SizedBox(height: 20),
              
              // Segundo Container
              ContainerTelaInicial(
                function: () =>  context.read<BottomNavigatorProvider>().index = 1, 
                color1: Color(0xFF0A8F14),
                color2: Color(0xFF0DB520),
                icon: Icons.eco, 
                titulo: "CarboCoins", 
                informacao: user.carboCoins.toString(), 
                mensagem: "Pontos acumulados",
              ),
              
              const SizedBox(height: 30),

              // Dica do dia
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Color.fromARGB(255, 5, 106, 12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF056A0C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Color(0xFF056A0C),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Dica do dia",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1a1a1a),
                            fontFamily: 'League Spartan',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Cada quilômetro pedalado contribui para um planeta mais sustentável e gera CarboCoins para você!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontFamily: 'Lao Muang Don',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              
              // Linha
              Row(
                children: [
                  // Conquistas
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<BottomNavigatorProvider>().index = 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 2,
                            color: Color.fromARGB(255, 5, 106, 12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 18, 95, 24).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: Color.fromARGB(255, 68, 126, 57),
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Conquistas",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1a1a1a),
                                fontFamily: 'Lao Muang Don',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  
                  // Progresso
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<BottomNavigatorProvider>().index = 4,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 2,
                            color: Color.fromARGB(255, 5, 106, 12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                      userProvider.dicaSelecionada!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontFamily: 'Lao Muang Don',
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.read<BottomNavigatorProvider>().index = 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 18, 95, 24).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: Color.fromARGB(255, 68, 126, 57),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Conquistas",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1a1a1a),
                                  fontFamily: 'Lao Muang Don',
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 18, 95, 24).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                color: Color.fromARGB(255, 68, 126, 57),
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Progresso",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1a1a1a),
                                fontFamily: 'Lao Muang Don',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}