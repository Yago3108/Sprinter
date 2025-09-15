import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;

class MapaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _uid;
  final List<GeoPoint> _rota = [];
  double _distancia = 0.0;
  Duration _tempo = Duration.zero;
  DateTime? _inicio;
  DateTime? _fim;
  Position? _ultimaPosicao;
  StreamSubscription<Position>? _stream;
    MapController? _controller;
    void setController(MapController controller) {
    _controller = controller;
  }
  void setUid(String uid) {
    _uid = uid;
  }
  final MapController controller = MapController(
    initMapWithUserPosition: UserTrackingOption(enableTracking: false),
  );
  StreamSubscription<Position>? _posicaoStream;

  void iniciarAtividade() {
    rota.clear();

    _posicaoStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, // mais preciso
        distanceFilter: 0, // pega todos os pontos
      ),
    ).listen((pos) async {
      final ponto = GeoPoint(latitude: pos.latitude, longitude: pos.longitude);
      rota.add(ponto);

      // Atualiza a posição no mapa
      await controller.moveTo(ponto);

      // Desenha a rota se houver pelo menos 2 pontos
      if (rota.length >= 2) {
        await controller.drawRoad(
          rota.first,
          rota.last,
          roadOption: const RoadOption(
            roadColor: Colors.green,
            roadWidth: 6,
          ),
        );
      }

      notifyListeners();
    });
  }
  List<GeoPoint> get rota => _rota;
  double get distancia => _distancia;
  Duration get tempo => _tempo;

  Future<void> pararAtividade() async {
    _fim = DateTime.now();
    _stream?.cancel();

    if (_inicio != null && _fim != null) {
      _tempo = _fim!.difference(_inicio!);
    }

    if (_uid != null) {
      await _firestore.collection('usuarios').doc(_uid).collection("atividades").add({
        'rota': _rota.map((ponto) => {'latitude': ponto.latitude, 'longitude': ponto.longitude}).toList(),
        'uid': _uid,
        'distancia': _distancia,
        'tempo': _tempo.inSeconds,
        'inicio': _inicio,
        'fim': _fim,
      });
    }

    notifyListeners();
  }
}