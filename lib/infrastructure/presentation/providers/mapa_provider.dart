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

    _posicaoStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      ),
    ).listen((pos) async {
      final ponto = GeoPoint(latitude: pos.latitude, longitude: pos.longitude);
      rota.add(ponto);

      // Atualiza a posição no mapa
      await controller.moveTo(ponto);

      if(!_marcadorInicializado){
        await controller.setStaticPosition([ponto], 'userPosition');
        await controller.setMarkerOfStaticPoint( 
          id: 'userPosition', 
          markerIcon: MarkerIcon(
            iconWidget: Icon(
              Icons.directions_sharp,
              color: Colors.green,
              size: 48,
            ),
          ),
        );
        _marcadorInicializado = true;
      } 
      else{
        await controller.setStaticPosition([ponto], 'userPosition');
      }

      bool atividadeParada = false;

      if(_ultimaPosicao != null && _ultimoTempo != null){
        final distanciaLocal = Distance().as(
          LengthUnit.Meter,
          LatLng(_ultimaPosicao!.latitude, _ultimaPosicao!.longitude),
          LatLng(pos.latitude, pos.longitude),
        );
        _distancia += distanciaLocal;

        final Duration tempoLocal = pos.timestamp.difference(_ultimoTempo!);

        if(tempoLocal.inSeconds > 0){

          _tempo += tempoLocal;

          final double velocidade = distanciaLocal / tempoLocal.inSeconds;

          final double velocidadeKm = velocidade * 3.6;

          if(velocidadeKm>40){

            atividadeParada = true;

            await pararAtividade(context);

            if (ModalRoute.of(context)?.isCurrent ?? false) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  
                  title: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color.fromARGB(255, 5, 106, 12),
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Alerta de Velocidade!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 106, 12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  content: const Text(
                    "Você está andando acima da velocidade permitida do aplicativo! Diminua a velocidade e reinicie a atividade.",
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text(
                        "Entendi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            
            notifyListeners();
          }
        }
      }

      if(!atividadeParada){
        _ultimaPosicao = pos;
        _ultimoTempo = pos.timestamp;

          if (rota.length >= 2) {
          final GeoPoint start = rota[rota.length - 2];
          final GeoPoint end = rota.last;

          if (start.latitude != end.latitude || start.longitude != end.longitude) {
            await controller.drawRoad(
              start,
              end,
              roadOption: const RoadOption(
                roadColor: Colors.green,
                roadWidth: 6,
              ),
            );
          }
        }
      }

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

    double emissao = fatorEmissao*(_distancia/1000);
    
    int pontos = (emissao/5).floor();
    

    final userProvider = Provider.of<UserProvider>(context,listen: false);
   userProvider.atualizarCC(pontos, emissao, distancia/1000);

    if (_uid != null) {
      await _firestore.collection('usuarios').doc(_uid).collection("atividades").add({
        'rota': _rota.map((ponto) => { 'latitude': ponto.latitude, 'longitude': ponto.longitude}).toList(),
        'uid': _uid,
        'distancia': _distancia,
        'tempo': _tempo.inSeconds,
        'inicio': _inicio,
        'fim': _fim,
        'emissao': emissao,
        'pontos': pontos
      });
    }

    notifyListeners();
  }
}