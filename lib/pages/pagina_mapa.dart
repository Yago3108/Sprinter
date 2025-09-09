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
  Stream<Position>? posStream;
  late MapaProvider _mapaProvider;
   double latitude=0;
  double longitude=0;

 

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
    MapController controller = MapController(
    initMapWithUserPosition: UserTrackingOption(
      enableTracking: true,
    ),
    
  );
   void iniciarAtividade() async {
    final atividade = context.read<MapaProvider>();
    atividade.iniciarAtividade();

    // escuta localização em tempo real
    posStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // só atualiza a cada 5 metros
      ),
    );

    posStream!.listen((pos) async {

      final geo = GeoPoint(latitude: pos.latitude, longitude: pos.longitude);
      await controller.currentLocation();
      await controller.addMarker(geo);
    });
  }

  void pararAtividade() {
    context.read<MapaProvider>().pararAtividade();
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
    bool clicou=true;
    if (latitude == null || longitude == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Scaffold(
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
              controller: controller,
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 5, 106, 12),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                   
                    },
                    child: clicou==true?IconButton(onPressed: () {
                          _mapaProvider.iniciarAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade iniciada"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    },
                      icon: Icon(Icons.play_arrow_sharp,color: Colors.white,)):IconButton(onPressed: () {
                          _mapaProvider.pararAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade parada"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    },
                      icon: Icon(Icons.stop,color: Colors.white,))
                  ),

                ],
              ),
            ),
          ],
        ),
      );
    
  }
}
