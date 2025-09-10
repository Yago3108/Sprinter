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
   bool clicou=false;
MapController controller= MapController(
  initMapWithUserPosition: UserTrackingOption(
    enableTracking: true,
  )
);
 

  @override
  void initState() {
    super.initState();
    _inicializarMapa();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _mapaProvider = Provider.of<MapaProvider>(context, listen: false);

    if (userProvider.user != null) {
      _mapaProvider.setUid(userProvider.user!.uid);
    }
  }
   void iniciarAtividade() async {
    final atividade = context.read<MapaProvider>();
    atividade.iniciarAtividade();

    
    }
    
  void pararAtividade() {
   final ativade= context.watch<MapaProvider>();
   ativade.pararAtividade();
  }
 Future<void> _inicializarMapa() async {
    // Verifica permissão
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

    // Pega localização
    Position posicao = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );

    // Cria o controller com initPosition
    setState(() {
      controller = MapController(
        initPosition: GeoPoint(
          latitude: posicao.latitude,
          longitude: posicao.longitude,
        ),
      );
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
           onMapIsReady: (isReady) {
              
           Consumer<MapaProvider>(
                builder: (context, mapa, _) {
                  if (mapa.rota.length >= 2) {
                    controller.drawRoad(
                      mapa.rota.first,   // início da caminhada
                      mapa.rota.last,    // último ponto atualizado
                      roadOption: const RoadOption(
                        roadColor: Color.fromARGB(255, 5, 106, 12),
                        roadWidth: 8,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
           },
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
                    backgroundColor: const Color.fromARGB(255, 5, 106, 12),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                     clicou= !clicou;
                    });

                    if (clicou!=false){ 
                      _mapaProvider.iniciarAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade iniciada"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    } else {
                      _mapaProvider.pararAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade parada"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    clicou ? Icons.stop : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      );
    
  }
}
