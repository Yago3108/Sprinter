import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:myapp/util/mapa_provider.dart';
import 'package:myapp/util/user_provider.dart';

class PaginaMapa extends StatefulWidget {
  const PaginaMapa({super.key});

  @override
  State<PaginaMapa> createState() => _PaginaMapaState();
}

class _PaginaMapaState extends State<PaginaMapa> {
  late MapaProvider _mapaProvider;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _mapaProvider = Provider.of<MapaProvider>(context, listen: false);

    if (userProvider.user != null) {
      _mapaProvider.setUid(userProvider.user!.uid);
    }
  }

  Future<void> _obterLocalizacaoAtual() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.deniedForever) return;
    }

    Position posicao = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );

    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            OSMFlutter(
              
              osmOption: OSMOption(
            zoomOption: ZoomOption(
              initZoom: 16),
                showContributorBadgeForOSM: false,
                showDefaultInfoWindow: false,
           
                roadConfiguration: RoadOption(
                  roadColor: const Color.fromARGB(255, 21, 77, 25),
                ),
              ),
              controller: MapController(
             
            initMapWithUserPosition: UserTrackingOption(
              enableTracking: true,
            )
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      _mapaProvider.iniciarAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade iniciada"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    },
                    child: Text("INICIAR"),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text("Parar"),
                    onPressed: () async {
                      await _mapaProvider.pararAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade salva"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
