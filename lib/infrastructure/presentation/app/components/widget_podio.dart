import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class WidgetPodioRanking extends StatefulWidget {
  final List<Map<String, dynamic>>? ranking;

  const WidgetPodioRanking({super.key, required this.ranking});

  @override
  State<WidgetPodioRanking> createState() => _WidgetPodioRankingState();
}

class _WidgetPodioRankingState extends State<WidgetPodioRanking> {
  // Função auxiliar para obter os dados do ganhador de cada posição
  Map<String, dynamic>? _getTopUser(int position) {
    if (widget.ranking!.length > position - 1) {
      return widget.ranking![position - 1];
    }
    return null;
  }

  // Função auxiliar para exibir a posição (1º, 2º ou 3º)
  Widget _buildPodiumItem(BuildContext context, int position) {
    final user = _getTopUser(position);
    final String label = "${position}º";
       final fotoBase64 = user?["Foto_perfil"];
        Uint8List? bytes;

      if (fotoBase64 != null) {
        setState(() {
          bytes = base64Decode(fotoBase64);
        });
      }
    // Altura relativa para simular o pódio
    double height;
    Color color;

    switch (position) {
      case 1:
        height = 100;
        color = Color.fromARGB(255, 5, 106, 12); // Ouro
        break;
      case 2:
        height = 70;
        color = Color.fromARGB(255, 76, 145, 81);// Prata
        break;
      case 3:
        height = 50;
        color = Color.fromARGB(255, 124, 185, 128); // Bronze
        break;
      default:
        return const SizedBox.shrink(); // Não deve acontecer
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Foto de Perfil / Nome
        if (user != null) ...[
          CircleAvatar(
            radius: 25,
            backgroundImage: bytes != null
                  ? MemoryImage(bytes!)
                  : AssetImage("assets/images/perfil_basico.jpg"),
            
          ),
          const SizedBox(height: 4),
          Text(
            user['nome'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontFamily: "League Spartan", color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
        ] else ...[
          const CircleAvatar(radius: 25, backgroundColor: Colors.transparent),
          const SizedBox(height: 6),
        ],

        // Bloco do Pódio
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        // Distância (Métrica do Ranking)
        if (user != null)
          Text(
            '${user['distancia'].toStringAsFixed(2)} m',
            style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pegamos apenas os 3 primeiros para o pódio
    final top3 = widget.ranking!.take(3).toList(); 

    if (top3.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end, // Alinha o pódio pela base
        children: [
          // 2º Lugar
          Flexible(child: _buildPodiumItem(context, 2)),
          
          // 1º Lugar (Geralmente no centro e mais alto)
          Flexible(child: _buildPodiumItem(context, 1)),
          
          // 3º Lugar
          Flexible(child: _buildPodiumItem(context, 3)),
        ],
      ),
    );
  }
}