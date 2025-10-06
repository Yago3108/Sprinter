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

    // percorre a lista
    for (var doc in atividadesSnap.docs) {
      final data = doc.data();
      DateTime fim = (data['fim'] as Timestamp).toDate();
      double distancia = data['distancia'] ?? 0.0;
      int tempo = data['tempo'] ?? 0.0;

      // identificadores
      String diaId = "${fim.year}-${fim.month}-${fim.day}";
      String semanaId = "${fim.year}-W${weekNumber(fim)}";
      String mesId = "${fim.year}-${fim.month}";
      String anoId = "${fim.year}";

      // adiciona na lista
      semanasTemp.putIfAbsent(semanaId, () => {
        'dias': {},
        'distanciaTotal': 0.0,
        'tempoTotal': 0.0,
      });

      // adiciona 0 nos dias sem atividade
      semanasTemp[semanaId]['dias'].putIfAbsent(diaId, () => {
        'distancia': 0.0,
        'tempo': 0.0,
      });

      semanasTemp[semanaId]['dias'][diaId]['distancia'] += distancia;
      semanasTemp[semanaId]['dias'][diaId]['tempo'] += tempo;
      semanasTemp[semanaId]['distanciaTotal'] += distancia;
      semanasTemp[semanaId]['tempoTotal'] += tempo;

      // adiciona na lista
      mesesTemp.putIfAbsent(mesId, () => {
        'semanas': {},
        'distanciaTotal': 0.0,
        'tempoTotal': 0.0,
      });

      // adiciona 0 nas semanas sem atividade
      mesesTemp[mesId]['semanas'].putIfAbsent(semanaId, () => {
        'distancia': 0.0,
        'tempo': 0.0,
      });

      mesesTemp[mesId]['semanas'][semanaId]['distancia'] += distancia;
      mesesTemp[mesId]['semanas'][semanaId]['tempo'] += tempo;
      mesesTemp[mesId]['distanciaTotal'] += distancia;
      mesesTemp[mesId]['tempoTotal'] += tempo;

      // adiciona na lista
      anosTemp.putIfAbsent(anoId, () => {
        'meses': {},
        'distanciaTotal': 0.0,
        'tempoTotal': 0.0,
      });

      // adiciona 0 nos meses sem atividade
      anosTemp[anoId]['meses'].putIfAbsent(mesId, () => {
        'distancia': 0.0,
        'tempo': 0.0,
      });

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

  // função para salvar as estatísticas
  Future<void> salvarEstatisticas(String userId) async {
    final userRef = _firestore.collection('usuarios').doc(userId);

    // salvar semanas
    for (var entry in _semanas.entries) {
      await userRef.collection('estatisticas')
          .doc('semanas')
          .collection('dados')
          .doc(entry.key)
          .set(entry.value);
    }

    // salvar meses
    for (var entry in _meses.entries) {
      await userRef.collection('estatisticas')
          .doc('meses')
          .collection('dados')
          .doc(entry.key)
          .set(entry.value);
    }

    // salvar anos
    for (var entry in _anos.entries) {
      await userRef.collection('estatisticas')
          .doc('anos')
          .collection('dados')
          .doc(entry.key)
          .set(entry.value);
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

        ranking.add({
          'uid': amigoId,
          'nome': nome,
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