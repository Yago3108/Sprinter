import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstatisticaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Modelos internos
  Map<String, dynamic> _semanas = {};
  Map<String, dynamic> _meses = {};
  Map<String, dynamic> _anos = {};

  Map<String, dynamic> get semanas => _semanas;
  Map<String, dynamic> get meses => _meses;
  Map<String, dynamic> get anos => _anos;

  Future<void> carregarAtividades(String userId) async {
    final atividadesSnap = await _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('atividades')
        .get();

    Map<String, dynamic> semanasTemp = {};
    Map<String, dynamic> mesesTemp = {};
    Map<String, dynamic> anosTemp = {};

    for (var doc in atividadesSnap.docs) {
      final data = doc.data();
      DateTime fim = (data['fim'] as Timestamp).toDate();
      double distancia = data['distancia'] ?? 0.0;
      int tempo = data['tempo'] ?? 0.0;

      // Identificadores
      String diaId = "${fim.year}-${fim.month}-${fim.day}";
      String semanaId = "${fim.year}-W${weekNumber(fim)}";
      String mesId = "${fim.year}-${fim.month}";
      String anoId = "${fim.year}";

      // -----------------------------
      // Nivel SEMANAL
      // -----------------------------
      semanasTemp.putIfAbsent(semanaId, () => {
            'dias': {},
            'distanciaTotal': 0.0,
            'tempoTotal': 0.0,
          });

      semanasTemp[semanaId]['dias'].putIfAbsent(diaId, () => {
            'distancia': 0.0,
            'tempo': 0.0,
          });

      semanasTemp[semanaId]['dias'][diaId]['distancia'] += distancia;
      semanasTemp[semanaId]['dias'][diaId]['tempo'] += tempo;
      semanasTemp[semanaId]['distanciaTotal'] += distancia;
      semanasTemp[semanaId]['tempoTotal'] += tempo;

      // -----------------------------
      // Nivel MENSAL
      // -----------------------------
      mesesTemp.putIfAbsent(mesId, () => {
            'semanas': {},
            'distanciaTotal': 0.0,
            'tempoTotal': 0.0,
          });

      mesesTemp[mesId]['semanas'].putIfAbsent(semanaId, () => {
            'distancia': 0.0,
            'tempo': 0.0,
          });

      mesesTemp[mesId]['semanas'][semanaId]['distancia'] += distancia;
      mesesTemp[mesId]['semanas'][semanaId]['tempo'] += tempo;
      mesesTemp[mesId]['distanciaTotal'] += distancia;
      mesesTemp[mesId]['tempoTotal'] += tempo;

      // -----------------------------
      // Nivel ANUAL
      // -----------------------------
      anosTemp.putIfAbsent(anoId, () => {
            'meses': {},
            'distanciaTotal': 0.0,
            'tempoTotal': 0.0,
          });

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

    // Salvar de volta no Firestore (estatísticas consolidadas)
    await salvarEstatisticas(userId);
  }

  Future<void> salvarEstatisticas(String userId) async {
    final userRef = _firestore.collection('usuarios').doc(userId);

    // Salvar semanas
    for (var entry in _semanas.entries) {
      await userRef.collection('estatisticas')
          .doc('semanas')
          .collection('dados')
          .doc(entry.key)
          .set(entry.value);
    }

    // Salvar meses
    for (var entry in _meses.entries) {
      await userRef.collection('estatisticas')
          .doc('meses')
          .collection('dados')
          .doc(entry.key)
          .set(entry.value);
    }

    // Salvar anos
    for (var entry in _anos.entries) {
      await userRef.collection('estatisticas')
          .doc('anos')
          .collection('dados')
          .doc(entry.key)
          .set(entry.value);
    }
  }

  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final diff = date.difference(firstDayOfYear).inDays + daysOffset;
    return (diff / 7).ceil();
  }
 Future<Map<String, dynamic>> rankingSemanal(String userId) async {
  final agora = DateTime.now();

  // Descobre a semana atual
  final semanaId = "${agora.year}-W${weekNumber(agora)}";

  final userRef = _firestore.collection('usuarios').doc(userId);

  // Buscar lista de amigos
  final amigosSnap = await userRef.collection('amizades').get();
  List<String> amigosIds = amigosSnap.docs.map((d) => d.id).toList();

  // Inclui o próprio usuário
  amigosIds.add(userId);

  List<Map<String, dynamic>> ranking = [];

  for (var amigoId in amigosIds) {
    final statsRef = _firestore
        .collection('usuarios')
        .doc(amigoId)
        .collection('estatisticas')
        .doc('semanas')
        .collection('dados')
        .doc(semanaId);

    final semanaDoc = await statsRef.get();

    // Verifica se tem dados dessa semana
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