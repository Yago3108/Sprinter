import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myapp/util/estatistica_provider.dart';
import 'package:provider/provider.dart';

enum Periodo { semana, mes, ano }

class GraficoHistorico extends StatefulWidget {
  final Periodo periodo;

  const GraficoHistorico({super.key, required this.periodo});

  @override
  _GraficoHistoricoState createState() => _GraficoHistoricoState();
}

class _GraficoHistoricoState extends State<GraficoHistorico> {
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;

  @override
  void initState() {
    super.initState();
    _setDados();
  }

  void _setDados() {
    final estatisticaProvider = context.read<EstatisticaProvider>();

    Map<String, dynamic>? dadosPeriodo;

    switch (widget.periodo) {
      case Periodo.semana:
        final semanaId =
            "${DateTime.now().year}-W${estatisticaProvider.weekNumber(DateTime.now())}";
        dadosPeriodo = estatisticaProvider.semanas[semanaId];
        break;
      case Periodo.mes:
        final mesId = "${DateTime.now().year}-${DateTime.now().month}";
        dadosPeriodo = estatisticaProvider.meses[mesId];
        break;
      case Periodo.ano:
        final anoId = "${DateTime.now().year}";
        dadosPeriodo = estatisticaProvider.anos[anoId];
        break;
    }

    if (dadosPeriodo == null) return;

    final dias = Map<String, dynamic>.from(dadosPeriodo['dias'] ?? {});

    dadosGrafico.clear();
    maxY = 0;

    final chavesOrdenadas = dias.keys.toList()..sort((a, b) => a.compareTo(b));

    for (int i = 0; i < chavesOrdenadas.length; i++) {
      final chave = chavesOrdenadas[i];
      final dadosDia = Map<String, dynamic>.from(dias[chave] ?? {});
    
      final distanciaKm = ((dadosDia['distancia'] ?? 0.0) as num).toDouble() / 1000.0;

      dadosGrafico.add(FlSpot(i.toDouble(), distanciaKm));

      if (distanciaKm > maxY) maxY = distanciaKm;
    }

    maxX = (dadosGrafico.isNotEmpty ? dadosGrafico.length - 1 : 0).toDouble();
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: maxY + 1,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                "${value.toStringAsFixed(1)} km",
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(),
        topTitles: AxisTitles(

        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();

              if (widget.periodo == Periodo.semana) {
                const diasNomes = [
                  'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'
                ];
                if (index >= 0 && index < diasNomes.length) {
                  return Text(diasNomes[index], style: const TextStyle(fontSize: 10));
                }
              }

              if (widget.periodo == Periodo.mes) {
                return Text("${index + 1}", style: const TextStyle(fontSize: 10));
              }

              if (widget.periodo == Periodo.ano) {
                const mesesNomes = [
                  'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
                  'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
                ];
                if (index >= 0 && index < mesesNomes.length) {
                  return Text(mesesNomes[index], style: const TextStyle(fontSize: 10));
                }
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: dadosGrafico,
          isCurved: true,
          color: Color.fromARGB(255, 5, 106, 12),
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _setDados();

    return AspectRatio(
      aspectRatio: 2,
      child: dadosGrafico.isEmpty
          ? const Center(child: Text("Sem dados"))
          : Padding(
            padding: const EdgeInsets.all(10.0),
            child: LineChart(getChartData()),
          ),
    );
  }
}
