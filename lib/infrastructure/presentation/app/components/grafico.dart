import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:provider/provider.dart';

enum Periodo { semana, mes, ano }

class GraficoHistorico extends StatefulWidget {
  final Periodo periodo;
  // NOVO: Adiciona a data de referência ao construtor
  final DateTime dataReferencia; 

  const GraficoHistorico({
    super.key, 
    required this.periodo, 
    required this.dataReferencia, // Adicionado
  });

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
   
  }

  int calcularSemanaDoMes(DateTime data) {
  final primeiroDiaDoMes = DateTime(data.year, data.month, 1);
  final deslocamento = primeiroDiaDoMes.weekday - 1; 
  final diaDoMes = data.day;
  return ((diaDoMes + deslocamento) / 7).ceil();
}
  void _setDados() {
    
    if (dadosGrafico.isNotEmpty && maxX > 0) return; 

    final estatisticaProvider = context.read<EstatisticaProvider>();
    final dataReferencia = widget.dataReferencia;
    int maxSemanas = 6;

    Map<String, dynamic>? dadosPeriodo; 
    
    // Lista de valores (eixo X) e distância (eixo Y) que iremos gerar
    dadosGrafico.clear();
    maxY = 0;
    
    List<double> distanciasCompletas = [];

    // --- Lógica para Semana ---
    if (widget.periodo == Periodo.semana) {
      // Começa no último domingo (ou segunda, dependendo da sua definição de semana)
      // Ajuste para começar na SEGUNDA-FEIRA (dia 1)
      final primeiroDiaDaSemana = dataReferencia.subtract(Duration(days: dataReferencia.weekday - 1));
      
      final semanaId =
          "${dataReferencia.year}-W${estatisticaProvider.weekNumber(dataReferencia)}";
      dadosPeriodo = estatisticaProvider.semanas[semanaId];

      final diasComDados = Map<String, dynamic>.from(dadosPeriodo?['dias'] ?? {});

      for (int i = 0; i < 7; i++) {
        final diaAtual = primeiroDiaDaSemana.add(Duration(days: i));
        // A chave no banco é 'yyyy-mm-dd'
        final chaveDia = "${diaAtual.year}-${diaAtual.month.toString().padLeft(2, '0')}-${diaAtual.day.toString().padLeft(2, '0')}";

        final dadosDia = Map<String, dynamic>.from(diasComDados[chaveDia] ?? {});
        final distanciaKm = ((dadosDia['distancia'] ?? 0.0) as num).toDouble() / 1000.0;
        
        distanciasCompletas.add(distanciaKm);
      }
      
      maxX = 6; // 7 dias (índices de 0 a 6)
    } 
    
    
    // --- Lógica para Mês ---
else if (widget.periodo == Periodo.mes) {
    // Calcula o ID do mês no formato 'YYYY-MM' (ex: 2025-09)
    final mesId = "${dataReferencia.year}-${dataReferencia.month.toString().padLeft(2, '0')}";
    

    final Map<String, dynamic> dadosPeriodo = Map<String, dynamic>.from(estatisticaProvider.meses[mesId] ?? {});


    final Map<String, dynamic> semanasComDados = 
        Map<String, dynamic>.from(dadosPeriodo['semanas'] ?? {});
    
    Map<String, double> distanciasPorSemana = {};

    List<String> semanasDoMesChaves = [];

   
    for (final chaveSemanaCompleta in semanasComDados.keys) {
        final dadosSemana = Map<String, dynamic>.from(semanasComDados[chaveSemanaCompleta] ?? {});

        final distanciaEmMetros = ((dadosSemana['distancia'] ?? 0.0) as num).toDouble();
        final distanciaKm = distanciaEmMetros / 1000.0;
        
        distanciasPorSemana[chaveSemanaCompleta] = distanciaKm;
    }
    
  
    semanasDoMesChaves = distanciasPorSemana.keys.toList()
                                          ..sort();
    
    
    for (int i = 0; i < semanasDoMesChaves.length; i++) {
        final chaveSemanaCompleta = semanasDoMesChaves[i];
        final distancia = distanciasPorSemana[chaveSemanaCompleta]!;
        distanciasCompletas.add(distancia);
        

    }
    
   
    maxX = distanciasCompletas.length.toDouble() - 1;
}
    
    // --- Lógica para Ano ---
    else if (widget.periodo == Periodo.ano) {
      final anoId = "${dataReferencia.year}";
      dadosPeriodo = estatisticaProvider.anos[anoId];
      
      final mesesComDados = Map<String, dynamic>.from(dadosPeriodo?['meses'] ?? {});

      for (int mes = 1; mes <= 12; mes++) {
        final chaveMes = "${dataReferencia.year}-${mes.toString().padLeft(2, '0')}";

        final dadosMes = Map<String, dynamic>.from(mesesComDados[chaveMes] ?? {});
        final distanciaKm = ((dadosMes['distancia'] ?? 0.0) as num).toDouble() / 1000.0;
        
        distanciasCompletas.add(distanciaKm);
      }
      maxX = 11; // 12 meses (índices de 0 a 11)
    }

    // Processa a lista completa para gerar os FlSpots e definir o maxY
    for (int i = 0; i < distanciasCompletas.length; i++) {
      final distancia = distanciasCompletas[i];
      dadosGrafico.add(FlSpot(i.toDouble(), distancia));
      if (distancia > maxY) maxY = distancia;
    }

    // Garante que o gráfico tenha pelo menos um ponto se houver dados
    if (dadosGrafico.isEmpty) maxX = 0;
  }

  // O restante do LineChartData e build permanecem.
  // ... (getChartData)

  LineChartData getChartData() {
    return LineChartData(
      // ... (Restante do LineChartData, sem alterações)
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
        topTitles: AxisTitles(),
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
                // Aqui usamos o index + 1, que é o número do dia (1 a 31)
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
          color: const Color.fromARGB(255, 5, 106, 12),
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
      child: dadosGrafico.isEmpty && maxX == 0 
          ? const Center(child: Text("Sem dados"))
          : Padding(
            padding: const EdgeInsets.all(10.0),
            child: LineChart(getChartData()),
          ),
    );
  }
}
