import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MapaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _uid;
  final List<GeoPoint> _rota = [];
  double _distancia = 0.0;
  Duration _tempo = Duration.zero;
  DateTime? _inicio;
  DateTime? _fim;
  DateTime? _ultimoTempo;
  Position? _ultimaPosicao;

  void setUid(String uid) {
    _uid = uid;
  }

  final MapController controller = MapController(
    initMapWithUserPosition: UserTrackingOption(enableTracking: false),
  );
  StreamSubscription<Position>? _posicaoStream;

  bool get isAtividadeAtiva => _posicaoStream != null;
  bool _marcadorInicializado = false;

  //INICIAR ATIVIDADE
  void iniciarAtividade(BuildContext context) {
    rota.clear();
    _distancia = 0.0;
    _tempo = Duration.zero;
    _inicio = DateTime.now();
    _ultimaPosicao = null;
    _ultimoTempo = null;
    _marcadorInicializado = false;

    _posicaoStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 1, // mais fluido
          ),
        ).listen((pos) async {
          final ponto = GeoPoint(
            latitude: pos.latitude,
            longitude: pos.longitude,
          );

          // ignora pequenas variações (ruído do GPS)
          if (_ultimaPosicao != null) {
            final distanciaLocal = Distance().as(
              LengthUnit.Meter,
              LatLng(_ultimaPosicao!.latitude, _ultimaPosicao!.longitude),
              LatLng(pos.latitude, pos.longitude),
            );
            if (distanciaLocal < 3) return; // ignora deslocamentos mínimos
            _distancia += distanciaLocal;
          }

          rota.add(ponto);

          // inicializa marcador do usuário
          if (!_marcadorInicializado) {
            await controller.setStaticPosition([ponto], 'userPosition');
            await controller.setMarkerOfStaticPoint(
              id: 'userPosition',
              markerIcon: MarkerIcon(
                iconWidget: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 48,
                ),
              ),
            );
            _marcadorInicializado = true;
          } else {
            // move suavemente o marcador existente entre a posição antiga e a nova
            if (_ultimaPosicao != null) {
              final oldLocation = GeoPoint(
                latitude: _ultimaPosicao!.latitude,
                longitude: _ultimaPosicao!.longitude,
              );
              await controller.changeLocationMarker(
                oldLocation: oldLocation,
                newLocation: ponto,
              );
            } else {
              // fallback (primeira atualização)
              await controller.setStaticPosition([ponto], 'userPosition');
            }
          }

          // atualiza a rota desenhada
          if (rota.length >= 2) {
            await controller.drawRoadManually(
              rota,
              const RoadOption(roadColor: Colors.green, roadWidth: 6),
            );
          }

          // atualiza tempo total
          if (_ultimoTempo != null) {
            final Duration tempoLocal = pos.timestamp.difference(_ultimoTempo!);
            if (tempoLocal.inSeconds > 0) {
              _tempo += tempoLocal;
            }
          }

          _ultimaPosicao = pos;
          _ultimoTempo = pos.timestamp;

          notifyListeners();
        });
  }

  List<GeoPoint> get rota => _rota;
  double get distancia => _distancia;
  Duration get tempo => _tempo;

  //PARAR ATIVIDADE
  Future<void> pararAtividade(BuildContext context) async {
    _fim = DateTime.now();
    _posicaoStream?.cancel();
    _posicaoStream = null;

    double fatorEmissao = 1.5;

    double emissao = fatorEmissao * (_distancia / 1000);

    int pontos = (emissao / 5).floor();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.atualizarCC(pontos, emissao, distancia / 1000);

    if (_uid != null) {
      await _firestore
          .collection('usuarios')
          .doc(_uid)
          .collection("atividades")
          .add({
            'rota': _rota
                .map(
                  (ponto) => {
                    'latitude': ponto.latitude,
                    'longitude': ponto.longitude,
                  },
                )
                .toList(),
            'uid': _uid,
            'distancia': _distancia,
            'tempo': _tempo.inSeconds,
            'inicio': _inicio,
            'fim': _fim,
            'emissao': emissao,
            'pontos': pontos,
          });
    }

    notifyListeners();
  }
}
