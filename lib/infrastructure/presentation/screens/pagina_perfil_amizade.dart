import 'dart:typed_data';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/entities/amigo.dart';
import 'package:myapp/entities/amizade.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/bottom_navigator_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:provider/provider.dart';

class PaginaPerfilAmizade extends StatefulWidget {
  final String uidAmigo;

  PaginaPerfilAmizade({super.key, required this.uidAmigo});

  @override
  PaginaPerfilAmizadeState createState() => PaginaPerfilAmizadeState();
}

class PaginaPerfilAmizadeState extends State<PaginaPerfilAmizade> {
  Usuario? amigo;
  Uint8List? fotoBytes;
  String? dataInicio;

  // Paleta de cores verde (copiada da PaginaPerfil)
  static const Color verdeEscuro = Color(0xFF1B5E20);
  static const Color verdeMedio = Color(0xFF2E7D32);
  static const Color verdeClaro = Color(0xFF4CAF50);
  static const Color verdeClaroSuave = Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.getUsuarioByUid(widget.uidAmigo);
  }

  // Novo widget auxiliar para os cards de estatísticas (copiado da PaginaPerfil)
  Widget _buildStatCard(String value, String label, Color verdeMedio, Color verdeClaro) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        // Aplica o Gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [verdeClaro, verdeMedio],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: verdeMedio.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Texto em branco para contraste com o gradiente
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 16,
              color: Colors.white, // Texto em branco
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Novo widget auxiliar para os campos de informação (copiado da PaginaPerfil)
  Widget _buildInfoField(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 18,
            color: verdeEscuro, // Cor do título
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: verdeMedio, width: 1.5), // Borda em verde médio
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'League Spartan',
                fontSize: 15,
                color: verdeEscuro, // Cor do texto
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatadorNumero = context.watch<BottomNavigatorProvider>();
    final userProvider = context.watch<UserProvider>();
    final AmizadeProvider amizadeProvider = context.watch<AmizadeProvider>();
    amizadeProvider.fetchAmizadesFromFirestore(userProvider.user!.uid);
    amigo = userProvider.usuarioPesquisado;

    for (var i = 0; i < amizadeProvider.amigos.length; i++) {
      Amigo amizade;
      amizade = amizadeProvider.amigos[i];
      final formatter = DateFormat('dd/MM/yyyy');

      if (amizade.uid == amigo?.uid) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              dataInicio = formatter.format(amizade.dataInicio);
            });
          }
        });
      }
    }

    try {
      fotoBytes = userProvider.usuarioPesquisado?.fotoPerfil;
    } catch (_) {
      fotoBytes = null;
    }

    return Scaffold(
      backgroundColor: verdeClaroSuave, // Define o background da tela como suave
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actionsPadding: const EdgeInsets.only(right: 10),
        backgroundColor: verdeMedio, // Cor do AppBar
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                // Foto de perfil
                CircleAvatar(
                  backgroundImage: fotoBytes != null && amigo!.fotoPerfil.isNotEmpty
                      ? MemoryImage(fotoBytes!, scale: 75)
                      : const AssetImage(
                          "assets/images/perfil_basico.jpg",
                        ) as ImageProvider,
                  radius: 75,
                  child: Container(
                    height: 375,
                    width: 375,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: verdeMedio, // Borda em verde médio
                      ),
                      borderRadius: BorderRadius.circular(75),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  amigo?.nome ?? "",
                  style: const TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 30,
                    color: verdeEscuro, // Cor do nome
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                // Cards de estatísticas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Card CarboCoins
                      _buildStatCard(
                        "${formatadorNumero.formatarNumero(amigo?.carboCoins)}" ?? "0",
                        "CarboCoins",
                        verdeMedio,
                        verdeClaro,
                      ),
                      // Card Distância
                      _buildStatCard(
                        "${formatadorNumero.formatarNumero(amigo?.distancia)}" ?? "0.0",
                        "Distância",
                        verdeMedio,
                        verdeClaro,
                      ),
                      // Card Carbono
                      _buildStatCard(
                        "${formatadorNumero.formatarNumero(amigo?.carbono)}" ?? "0",
                        "Carbono",
                        verdeMedio,
                        verdeClaro,
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                // Container de Informações Detalhadas
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white, // Cor de fundo do container
                    border: Border.all(color: verdeMedio.withOpacity(0.5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      // Email
                      _buildInfoField(
                        "Email",
                        amigo?.email ?? "",
                      ),
                      
                      // Início da amizade (condicional)
                      amizadeProvider.verificarAmigo(widget.uidAmigo)
                          ? Column(
                              children: [
                                const Padding(padding: EdgeInsets.only(top: 30)),
                                _buildInfoField(
                                  "Início da amizade",
                                  dataInicio ?? "",
                                ),
                              ],
                            )
                          : const SizedBox(),

                      const Padding(padding: EdgeInsets.only(top: 30)),
                      
                      // Data de nascimento
                      _buildInfoField(
                        "Data de nascimento",
                        amigo?.nascimento ?? "",
                      ),

                      const Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),

                // Botão de Adicionar Amigo ou Texto "Seu Amigo"
                amizadeProvider.verificarAmigo(widget.uidAmigo) == false
                    ? IconButton(
                        onPressed: () {
                          amizadeProvider.enviarPedidoAmizade(
                            userProvider.user!.nome,
                            userProvider.user!.uid,
                            widget.uidAmigo,
                          );
                          Navigator.pop(context);
                        },
                        icon: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: verdeMedio, // Cor do botão de adicionar amigo
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                               BoxShadow(
                                color: verdeMedio.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      )
                    : Text(
                        "Seu Amigo",
                        style: TextStyle(
                          fontFamily: "League Spartan",
                          fontSize: 30,
                          color: verdeEscuro, // Cor do texto "Seu Amigo"
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const Padding(padding: EdgeInsets.only(bottom: 30)), // Espaçamento inferior
              ],
            ),
          ],
        ),
      ),
    );
  }
}