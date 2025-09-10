import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;

class MapaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _uid;
  List<GeoPoint> _rota = [];
  double _distancia = 0.0;
  Duration _tempo = Duration.zero;
  DateTime? _inicio;
  DateTime? _fim;
  Position? _ultimaPosicao;
  StreamSubscription<Position>? _stream;

  void setUid(String uid) {
    _uid = uid;
  }

  List<GeoPoint> get rota => _rota;
  double get distancia => _distancia;
  Duration get tempo => _tempo;

  void iniciarAtividade() {
    _rota.clear();
    _distancia = 0;
    _tempo = Duration.zero;
    _inicio = DateTime.now();
    _fim = null;

    _stream = Geolocator.getPositionStream(
       locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0, // não ignora nenhum movimento
      timeLimit: Duration(seconds: 1),
    ),
    ).listen((posicao) {
      final atual = GeoPoint(latitude: posicao.latitude, longitude: posicao.longitude);
      if (_ultimaPosicao != null) {
        _distancia += Geolocator.distanceBetween(
          _ultimaPosicao!.latitude,
          _ultimaPosicao!.longitude,
          atual.latitude,
          atual.longitude,
        );
      }
  
      _rota.add(atual);
      _ultimaPosicao = posicao;
      notifyListeners();
    });
  }

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