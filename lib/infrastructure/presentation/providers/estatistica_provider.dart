import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstatisticaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // listas
  Map<String, dynamic> _semanas = {};
  Map<String, dynamic> _meses = {};
  Map<String, dynamic> _anos = {};

  // getter para as listas
  Map<String, dynamic> get semanas => _semanas;
  Map<String, dynamic> get meses => _meses;
  Map<String, dynamic> get anos => _anos;

  // carrega as atividades
 Future<void> carregarAtividades(String userId) async {
    final atividadesSnap = await _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('atividades')
        .get();

    // listas pra receber o banco de dados
    Map<String, dynamic> semanasTemp = {};
    Map<String, dynamic> mesesTemp = {};
    Map<String, dynamic> anosTemp = {};

    // Função auxiliar para criar a estrutura completa de 12 meses
    Map<String, dynamic> _criarEstruturaMesesDoAno(int ano) {
      Map<String, dynamic> meses = {};
      for (int mes = 1; mes <= 12; mes++) {
        final mesId = "$ano-${mes.toString().padLeft(2, '0')}";
        meses[mesId] = {
          'distancia': 0.0,
          'tempo': 0,
        };
      }
      return meses;
    }

    // percorre a lista
    for (var doc in atividadesSnap.docs) {
      final data = doc.data();
      DateTime fim = (data['fim'] as Timestamp).toDate();
      // Usando '?? 0.0' e '?? 0' para garantir os tipos corretos
      double distancia = (data['distancia'] ?? 0.0).toDouble();
      int tempo = (data['tempo'] ?? 0).toInt(); 

      // identificadores
      String diaId = "${fim.year}-${fim.month.toString().padLeft(2, '0')}-${fim.day.toString().padLeft(2, '0')}";
      String semanaId = "${fim.year}-W${weekNumber(fim)}";
      String mesId = "${fim.year}-${fim.month.toString().padLeft(2, '0')}"; // PadLeft adicionado para consistência
      String anoId = "${fim.year}";

      // ===================================
      // Lógica de Semanas (Sem alteração)
      // ===================================
      semanasTemp.putIfAbsent(semanaId, () => {
        'dias': {},
        'distanciaTotal': 0.0,
        'tempoTotal': 0,
      });

      semanasTemp[semanaId]['dias'].putIfAbsent(diaId, () => {
        'distancia': 0.0,
        'tempo': 0,
      });

      semanasTemp[semanaId]['dias'][diaId]['distancia'] += distancia;
      semanasTemp[semanaId]['dias'][diaId]['tempo'] += tempo;
      semanasTemp[semanaId]['distanciaTotal'] += distancia;
      semanasTemp[semanaId]['tempoTotal'] += tempo;

      // ===================================
      // Lógica de Meses (Sem alteração)
      // ===================================
      mesesTemp.putIfAbsent(mesId, () => {
        'semanas': {},
        'distanciaTotal': 0.0,
        'tempoTotal': 0,
      });

      // adiciona 0 nas semanas sem atividade (o id da semana é 'year-WweekNumber')
      mesesTemp[mesId]['semanas'].putIfAbsent(semanaId, () => {
        'distancia': 0.0,
        'tempo': 0,
      });

      mesesTemp[mesId]['semanas'][semanaId]['distancia'] += distancia;
      mesesTemp[mesId]['semanas'][semanaId]['tempo'] += tempo;
      mesesTemp[mesId]['distanciaTotal'] += distancia;
      mesesTemp[mesId]['tempoTotal'] += tempo;


      // ====================================================
      // Lógica de Anos (MODIFICADA para preencher os 12 meses)
      // ====================================================
      anosTemp.putIfAbsent(anoId, () {
        // Inicializa o ano com 12 meses preenchidos com zeros
        return {
          'meses': _criarEstruturaMesesDoAno(fim.year),
          'distanciaTotal': 0.0,
          'tempoTotal': 0,
        };
      });

      // Nota: Não é necessário putIfAbsent para o mês aqui,
      // pois _criarEstruturaMesesDoAno garante que todos os 12 meses (mesId) já existem.
      // O campo do mês dentro do ano é simples (distancia e tempo),
      // não é necessário um sub-mapa 'dias' ou 'semanas' aqui.

      anosTemp[anoId]['meses'][mesId]['distancia'] += distancia;
      anosTemp[anoId]['meses'][mesId]['tempo'] += tempo;
      anosTemp[anoId]['distanciaTotal'] += distancia;
      anosTemp[anoId]['tempoTotal'] += tempo;
    }

    _semanas = semanasTemp;
    _meses = mesesTemp;
    _anos = anosTemp;

    notifyListeners();

    // salvar de volta no firestore
    await salvarEstatisticas(userId);
}
Future<void> salvarEstatisticas(String userId) async {
  final userRef = _firestore.collection('usuarios').doc(userId);

  // ... (salvar semanas e meses)

  // salvar anos
  for (var entry in _anos.entries) {
    await userRef.collection('estatisticas')
        .doc('anos')
        .collection('dados')
        .doc(entry.key) // o key é o anoId, ex: "2023"
        .set(entry.value); // o value contém o mapa 'meses' com 12 entradas
  }
}
  // calcula número da semana
  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final diff = date.difference(firstDayOfYear).inDays + daysOffset;
    return (diff / 7).ceil();
  }

  // ranking semanal
  Future<Map<String, dynamic>> rankingSemanal(String userId) async {

    // data atual
    final agora = DateTime.now();

    // descobre a semana atual
    final semanaId = "${agora.year}-W${weekNumber(agora)}";

    final userRef = _firestore.collection('usuarios').doc(userId);

    // buscar lista de amigos
    final amigosSnap = await userRef.collection('amizades').get();
    List<String> amigosIds = amigosSnap.docs.map((d) => d.id).toList();

    // inclui o próprio usuário
    amigosIds.add(userId);

    // lista do ranking
    List<Map<String, dynamic>> ranking = [];
    
    //itera sobre a lista
    for (var amigoId in amigosIds) {
      final statsRef = _firestore
          .collection('usuarios')
          .doc(amigoId)
          .collection('estatisticas')
          .doc('semanas')
          .collection('dados')
          .doc(semanaId);

      final semanaDoc = await statsRef.get();

      // verifica se tem dados dessa semana
      if (!semanaDoc.exists) {
        continue;
      }

      final dadosSemana = semanaDoc.data() ?? {};
      final totalDistancia = (dadosSemana['distanciaTotal'] ?? 0.0).toDouble();
      final totalTempo = (dadosSemana['tempoTotal'] ?? 0.0).toDouble();

      if (totalDistancia > 0 || totalTempo > 0) {
        final amigoDoc = await _firestore.collection('usuarios').doc(amigoId).get();
        final nome = amigoDoc.data()?['nome'] ?? 'Sem Nome';
        final fotoperfil=amigoDoc.data()?["Foto_perfil"]?? "";
        ranking.add({
          'uid': amigoId,
          'nome': nome,
          "Foto_perfil":fotoperfil,
          'distancia': totalDistancia,
          'tempo': totalTempo,
        });
      }
    }

    // Ordena por distância (maior primeiro)
    ranking.sort((a, b) => b['distancia'].compareTo(a['distancia']));

    // Descobre posição do usuário atual
    int posicaoUsuario = ranking.indexWhere((e) => e['uid'] == userId);
    if (posicaoUsuario != -1) {
      posicaoUsuario += 1; // posição começa em 1
    }

    return {
      'ranking': ranking,
      'posicaoUsuario': posicaoUsuario,
    };
  }

}