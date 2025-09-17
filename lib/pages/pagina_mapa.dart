import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
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
  bool clicou = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _mapaProvider = Provider.of<MapaProvider>(context, listen: false);

    if (userProvider.user != null) {
      _mapaProvider.setUid(userProvider.user!.uid);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final mapa = context.watch<MapaProvider>();

    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapa.controller,
          
            osmOption: OSMOption(
          
              zoomOption: ZoomOption(initZoom: 16),
              showDefaultInfoWindow: false,
              roadConfiguration: const RoadOption(
                roadColor: Color.fromARGB(255, 21, 77, 25),
              ),
            ),
          ),

          // Botão iniciar/parar
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
                      clicou = !clicou;
                    });

                    if (clicou) {
                      mapa.iniciarAtividade();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade iniciada"),
                          backgroundColor: Color.fromARGB(255, 5, 106, 12),
                        ),
                      );
                    } else {
                      mapa.pararAtividade();
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