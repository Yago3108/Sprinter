import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/widgets/widget_podio.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil_amizade.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/entities/pedido.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:myapp/infrastructure/presentation/widgets/widget_pesquisaUsuario.dart';
import 'package:provider/provider.dart';

class PaginaAmizades extends StatefulWidget {
  const PaginaAmizades({super.key});

  @override
  State<PaginaAmizades> createState() => _PaginaAmizadesState();
}

class _PaginaAmizadesState extends State<PaginaAmizades> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OverlayEntry? _overlayEntry;
  
  List<Map<String, dynamic>> _rankingList = [];
  int? _posicaoUsuario;
  bool _carregandoRanking = true;
  List<Usuario> amigos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarTodosAmigos();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final amizadeProvider = context.read<AmizadeProvider>();
      final userUid = context.read<UserProvider>().user?.uid;
      
      if (userUid != null) {
        amizadeProvider.fetchAmizadesFromFirestore(userUid);
        amizadeProvider.fetchPedidosFromFirestore(userUid);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_carregandoRanking) {
      _carregarRanking();
    }
  }

  @override
  void dispose() {
    _removerPesquisa();
    super.dispose();
  }

  Future<void> _carregarRanking() async {
    final estatisticaProvider = Provider.of<EstatisticaProvider>(context, listen: false);
    final uid = context.read<UserProvider>().user?.uid;

    if (uid == null) return;

    try {
      final data = await estatisticaProvider.rankingSemanal(uid);
      if (mounted) {
        setState(() {
          _rankingList = data['ranking'] as List<Map<String, dynamic>>;
          _posicaoUsuario = data['posicaoUsuario'] as int?;
          _carregandoRanking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregandoRanking = false;
        });
        print("Erro ao carregar ranking: $e");
      }
    }
  }

  Future<void> carregarTodosAmigos() async {
    try {
      final userProvider = context.read<UserProvider>();
      final Usuario? user = userProvider.user;

      if (user == null) return;

      final amizadesSnapshot = await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .collection('amizades')
          .get();

      List<Usuario> listaTemp = [];

      for (var amizadeDoc in amizadesSnapshot.docs) {
        final uidAmigo = amizadeDoc['uid'];
        final doc = await _firestore.collection('usuarios').doc(uidAmigo).get();

        if (doc.exists) {
          listaTemp.add(
            Usuario(
              amigos: [],
              uid: doc['uid'],
              nome: doc['nome'],
              email: doc['email'],
              cpf: doc['cpf'],
              nascimento: doc['nascimento'],
              carboCoins: (doc['carboCoins'] ?? 0).round(),
              carbono: (doc['carbono'] ?? 0),
              distancia: (doc['distancia'] ?? 0),
              fotoPerfil: base64Decode(doc['Foto_perfil']),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          amigos = listaTemp;
          carregando = false;
        });
      }
    } catch (e) {
      print("Erro ao carregar amigos: $e");
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void _mostrarPesquisa(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: _removerPesquisa,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Material(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Buscar Amigos",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a1a1a),
                                fontFamily: 'League Spartan',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 24),
                              onPressed: _removerPesquisa,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        WidgetPesquisaUsuario(
                          onProdutoSelecionado: (uidAmigo) {
                            _removerPesquisa();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaginaPerfilAmizade(uidAmigo: uidAmigo),
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
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removerPesquisa() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final amizadeProvider = context.watch<AmizadeProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Barra de pesquisa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => _mostrarPesquisa(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Buscar amigos...",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontFamily: 'Lao Muang Don',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Pódio de ranking
              WidgetPodioRanking(ranking: _rankingList),
              
              const SizedBox(height: 24),
              
              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: const Color(0xFF056A0C),
                  unselectedLabelColor: Colors.grey[600],
                  indicator: BoxDecoration(
                    color: const Color(0xFF056A0C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'League Spartan',
                  ),
                  tabs: const [
                    Tab(text: 'Amizades'),
                    Tab(text: 'Ranking'),
                    Tab(text: 'Pedidos'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tab bar view
              Expanded(
                child: TabBarView(
                  children: [
                    // Aba Amizades
                    carregando
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF056A0C)),
                            ),
                          )
                        : amigos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Nenhum amigo encontrado",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontFamily: 'Lao Muang Don',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                itemCount: amigos.length,
                                itemBuilder: (context, index) {
                                  final amigo = amigos[index];
                                  final bytes = amigo.fotoPerfil;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: InkWell(
                                      onTap: () {
                                        final userProvider = context.read<UserProvider>();
                                        userProvider.getUsuarioByUid(amigo.uid);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PaginaPerfilAmizade(uidAmigo: amigo.uid),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundImage: (bytes != null && bytes.isNotEmpty)
                                                  ? MemoryImage(bytes) as ImageProvider
                                                  : const AssetImage("assets/images/perfil_basico.jpg"),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    amigo.nome,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF1a1a1a),
                                                      fontFamily: 'League Spartan',
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    amigo.email,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                      fontFamily: 'Lao Muang Don',
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF056A0C).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.eco,
                                                    color: Color(0xFF056A0C),
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${amigo.carboCoins}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF056A0C),
                                                      fontFamily: 'League Spartan',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    
                    // Aba Ranking
                    _carregandoRanking
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF056A0C)),
                            ),
                          )
                        : _rankingList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Nenhum dado de ranking encontrado",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontFamily: 'Lao Muang Don',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                itemCount: _posicaoUsuario != null ? _rankingList.length + 1 : _rankingList.length,
                                itemBuilder: (context, index) {
                                  if (index == 0 && _posicaoUsuario != null) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF056A0C), Color(0xFF078A10)],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF056A0C).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.emoji_events,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Você está em $_posicaoUsuarioº lugar!",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: 'League Spartan',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  final rankingIndex = _posicaoUsuario != null ? index - 1 : index;
                                  final item = _rankingList[rankingIndex];
                                  final posicao = rankingIndex + 1;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: posicao <= 3
                                                  ? const Color(0xFF056A0C)
                                                  : Colors.grey[300],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "$posicaoº",
                                                style: TextStyle(
                                                  color: posicao <= 3 ? Colors.white : Colors.grey[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  fontFamily: 'League Spartan',
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['nome'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1a1a1a),
                                                    fontFamily: 'League Spartan',
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.straighten,
                                                      size: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "${item['distancia'].toStringAsFixed(2)} m",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[600],
                                                        fontFamily: 'Lao Muang Don',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Icon(
                                                      Icons.timer,
                                                      size: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "${item['tempo'].toStringAsFixed(1)} seg",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[600],
                                                        fontFamily: 'Lao Muang Don',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    
                    // Aba Pedidos
                    amizadeProvider.pedidos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Nenhum pedido de amizade",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontFamily: 'Lao Muang Don',
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            itemCount: amizadeProvider.pedidos.length,
                            itemBuilder: (context, index) {
                              final pedido = amizadeProvider.pedidos[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF056A0C).withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person_add,
                                          color: Color(0xFF056A0C),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pedido.nomeRemetente,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1a1a1a),
                                                fontFamily: 'League Spartan',
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Pedido de amizade",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                                fontFamily: 'Lao Muang Don',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            amizadeProvider.aceitarPedidoAmizade(
                                              pedido.remetenteId,
                                              context.read<UserProvider>().user!.uid,
                                            );
                                            amizadeProvider.fetchPedidosFromFirestore(
                                              context.read<UserProvider>().user!.uid,
                                            );
                                            carregarTodosAmigos();
                                          });
                                        },
                                        icon: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            amizadeProvider.negarPedidoAmizade(
                                              pedido.remetenteId,
                                              context.read<UserProvider>().user!.uid,
                                            );
                                            amizadeProvider.fetchPedidosFromFirestore(
                                              context.read<UserProvider>().user!.uid,
                                            );
                                          });
                                        },
                                        icon: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}