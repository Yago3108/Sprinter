import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_esqueceu_senha.dart';
import 'package:provider/provider.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  PaginaPerfilState createState() => PaginaPerfilState();
}

class PaginaPerfilState extends State<PaginaPerfil> {
  // Paleta de cores verde
  static const Color verdeEscuro = Color(0xFF1B5E20);
  static const Color verdeMedio = Color(0xFF2E7D32);
  static const Color verdeClaro = Color(0xFF4CAF50);
  static const Color verdeClaroSuave = Color(0xFFE8F5E9);
  
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user!.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null) {
      bytes = base64Decode(fotoBase64);
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        backgroundColor: verdeMedio,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Pagina()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: bytes != null && bytes.isNotEmpty
                  ? MemoryImage(bytes)
                  : const AssetImage("assets/images/perfil_basico.jpg") as ImageProvider,
              radius: 20,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            Column(
              children: [
                // Foto de perfil
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: verdeMedio,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: bytes != null && bytes.isNotEmpty
                            ? MemoryImage(bytes)
                            : const AssetImage("assets/images/perfil_basico.jpg") as ImageProvider,
                        radius: 75,
                        backgroundColor: verdeClaroSuave,
                      ),
                    ),
                    Positioned(
                      bottom: -3,
                      child: Container(
                        height: 15,
                        width: 15,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      child: InkWell(
                        onTap: () => userProvider.selecionarImagem(),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_circle,
                            size: 30,
                            color: verdeMedio,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Nome do usuário
                Text(
                  userProvider.user?.nome ?? "",
                  style: const TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: verdeEscuro,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Cards de estatísticas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        userProvider.user?.carboCoins.toString() ?? "0",
                        "CarboCoins",
                      ),
                      _buildStatCard(
                        userProvider.user?.distancia.toStringAsFixed(1) ?? "0.0",
                        "Distância",
                      ),
                      _buildStatCard(
                        userProvider.user?.carbono.toStringAsFixed(0) ?? "0",
                        "Carbono",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Container com informações
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: verdeClaroSuave,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Email
                      _buildInfoField(
                        "Email",
                        userProvider.user?.email ?? "",
                      ),
                      const SizedBox(height: 30),
                      
                      // Data de nascimento
                      _buildInfoField(
                        "Data de nascimento",
                        userProvider.user?.nascimento ?? "",
                      ),
                      const SizedBox(height: 30),
                      
                      // Carbono não emitido
                      _buildInfoField(
                        "Carbono não emitido",
                        "${userProvider.user?.carbono.toStringAsFixed(2)} kg CO2",
                      ),
                      const SizedBox(height: 30),
                      
                      // Senha
                      const Text(
                        "Senha",
                        style: TextStyle(
                          fontFamily: 'League Spartan',
                          fontSize: 18,
                          color: verdeEscuro,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: verdeMedio, width: 1.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 12, color: verdeMedio),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      
                      // Botão Alterar Senha
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaginaEsqueceuSenha(),
                            ),
                          );
                        },
                        child: const Text(
                          "Alterar Senha",
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            color: verdeMedio,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: verdeMedio,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget auxiliar para cards de estatísticas
  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget auxiliar para campos de informação
  Widget _buildInfoField(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 18,
            color: verdeEscuro,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: verdeMedio, width: 1.5),
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'League Spartan',
                fontSize: 15,
                color: verdeEscuro,
              ),
            ),
          ),
        ),
      ],
    );
  }
}