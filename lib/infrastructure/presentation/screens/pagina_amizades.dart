import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil_amizade.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/entities/pedido.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:myapp/infrastructure/presentation/app/components/widget_pesquisaUsuario.dart';
import 'package:provider/provider.dart';

class PaginaAmizades extends StatefulWidget {
  const PaginaAmizades({super.key});

  @override
  State<PaginaAmizades> createState() => _PaginaAmizadesState();
}
OverlayEntry? _overlayEntry;


  void _mostrarPesquisa(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: _removerPesquisa,
          child: Material(
            color: const Color.fromARGB(85, 0, 0, 0),
            
             // fundo semitransparente
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 85, left: 16, right: 16),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      WidgetPesquisaUsuario(
                        onProdutoSelecionado: (uidAmigo) {
                        _removerPesquisa();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaginaPerfilAmizade(null, uidAmigo: uidAmigo, ),
                          ),
                        );
                      }
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _removerPesquisa,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

class _PaginaAmizadesState extends State<PaginaAmizades> {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>>? _rankingFuture;

  List<Usuario> amigos = [];
  bool carregando = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final estatisticaProvider =
        Provider.of<EstatisticaProvider>(context, listen: false);
    _rankingFuture ??= estatisticaProvider.rankingSemanal(context.watch<UserProvider>().user!.uid);
  }


  @override
  void initState() {
    super.initState();
       carregarTodosAmigos();
       
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

      setState(() {
        amigos = listaTemp;
        carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar amigos: $e");
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
  AmizadeProvider amizadeProvider = context.watch<AmizadeProvider>();
  final estatisticaProvider = Provider.of<EstatisticaProvider>(context, listen: false);
  

  setState(() {
      amizadeProvider.fetchAmizadesFromFirestore(context.read<UserProvider>().user!.uid);
  amizadeProvider.fetchPedidosFromFirestore(context.read<UserProvider>().user!.uid);
  });


    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Color.fromARGB(255, 5, 106, 12),
                      width: 2.0,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _mostrarPesquisa(context);
                    },
                    icon: Row(
                      children: [
                        Text("Pesquisar amigo..."),
                        Padding(padding: EdgeInsetsGeometry.only(left: 120)),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),
              Padding(padding: EdgeInsets.only(top: 60)),
              TabBar(
                dividerColor: Colors.white,
                labelColor: Color.fromARGB(255, 5, 106, 12),
                unselectedLabelColor: Colors.black,
                indicatorColor: Color.fromARGB(255, 0, 128, 0),
                tabs: [
                  Tab(text: 'Amizades'),
                  Tab(text: "Ranking"),
                  Tab(text: 'Pedidos'),
                ],
              ),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    
                    amizadeProvider.fetchAmizadesFromFirestore(context.read<UserProvider>().user!.uid);
                    amizadeProvider.fetchPedidosFromFirestore(context.read<UserProvider>().user!.uid);
                  },
                  child: TabBarView(
                    children: [
                  
                      //amizades
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:  const Color.fromARGB(255, 207, 207, 207),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:
                        amizadeProvider.amizades.isEmpty
                            ? Text('Nenhum amigo encontrado.')
                            : ListView.builder(
                       
                                itemCount: amigos.length,
                                itemBuilder: (context, index) {
                                      Usuario amigo1=amigos[index];
                                  Uint8List? bytes = amigo1.fotoPerfil;
                                  return amigo1 !=null ?Column(
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.only(top:10)),
                                      GestureDetector(
                                        onTap: () {
                                            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaginaPerfilAmizade(null, uidAmigo: amigo1.uid, ),
                          ),
                        );
                                        },
                                        child: Container(
                                          width: 400,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                            border: Border.all(
                                                  color: Color.fromARGB(255, 5, 106, 12),
                                                width: 1,
                                              
                                            ),
                                          ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(    padding: EdgeInsets.only(left: 10), ),
                                              
                                                  CircleAvatar(
                                                    radius: 18,
                                                    backgroundImage: (bytes != null && amigo1.fotoPerfil.isNotEmpty)
                                                        ? MemoryImage(bytes)
                                                        : AssetImage("assets/images/perfil_basico.jpg"),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(left: 20)),
                                                  Text(amigo1.nome,style: TextStyle(
                                                    fontSize: 15,
                                                                                    
                                                                                    fontFamily: 'League Spartan',
                                                    color: Color.fromARGB(255, 5, 106, 12
                                                  ),),),
                                                  Padding(padding: EdgeInsets.only(left: 20)),
                                                  Text('${amigo1.carboCoins.toStringAsFixed(0)} Cc',style: TextStyle(
                                                    fontSize: 15,
                                                                                    fontFamily: 'League Spartan',
                                                    color: Color.fromARGB(255, 5, 106, 12
                                                  ),),),
                                                       Padding(padding: EdgeInsets.only(left: 20)),
                                                  Text(amigo1.email,style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'League Spartan',
                                                    color: Color.fromARGB(255, 5, 106, 12
                                                  ),),),
                                                ],
                                              ),
                                            ),
                                          
                                        ),
                                      ),
                                    ],
                                  ):Text( "Carregando... ");
                              
                                },
                              ),
                      )),







                      //ranking
                      Center(child: FutureBuilder<Map<String, dynamic>>(
        future: _rankingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          if (!snapshot.hasData || (snapshot.data?['ranking'] as List).isEmpty) {
            return const Center(child: Text("Nenhum dado encontrado."));
          }

          final ranking = snapshot.data!['ranking'] as List<Map<String, dynamic>>;
          final posicaoUsuario = snapshot.data!['posicaoUsuario'] as int?;

          return Column(
            children: [
              if (posicaoUsuario != null)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Você está em $posicaoUsuarioº lugar esta semana!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "League Spartan",
                      color: Color.fromARGB(255, 5, 106, 12)
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: ranking.length,
                  itemBuilder: (context, index) {
                    final item = ranking[index];
                    return Padding(
                      padding: EdgeInsets.only(top:8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(
                            color: Color.fromARGB(255, 5, 106, 12),
                            width: 2,
),
                          borderRadius: BorderRadius.circular(35)
                        ),
                       height: 80,
                       width: 300,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 5, 106, 12),
                            child: Text("${index + 1}º",style: TextStyle(
                              color: Colors.white
                            ),),
                          ),
                          title: Text(item['nome'],style: TextStyle(
                                  fontSize: 19
                                ),),
                          subtitle: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  "Distância: ${item['distancia'].toStringAsFixed(2)} m",style: TextStyle(
                                  fontSize: 17
                                ),
                                ),
                                Padding(padding: EdgeInsetsGeometry.only(right: 5)),
                                Text("Tempo: ${item['tempo'].toStringAsFixed(1)} seg",style: TextStyle(
                                  fontSize: 17
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),),
                      //pedidos
                      Center(child: Container(
                          padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:  const Color.fromARGB(255, 207, 207, 207),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:
                        amizadeProvider.pedidos.isEmpty
                            ? Text('Nenhum pedido encontrado.')
                            : ListView.builder(
                       
                                itemCount: amizadeProvider.pedidos.length,
                                itemBuilder: (context, index) {
                                       
                                      
                                      PedidoAmizade pedido=amizadeProvider.pedidos[index];
                                  return pedido!=null ?Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                      border: Border.all(
                                            color: Color.fromARGB(255, 5, 106, 12),
                                          width: 1,
                                        
                                      ),
                                    ),
                                    child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 20)),
                                        Text(pedido.nomeRemetente,style: TextStyle(
                                          fontSize: 16,
                  
                                  fontFamily: 'League Spartan',
                                          color: Color.fromARGB(255, 5, 106, 12
                                        ),),),
                                        Padding(padding: EdgeInsets.only(left: 20)),
                                       Text("Aceitar pedido de amizade?",style: TextStyle(
                                          fontSize: 12,
                                  fontFamily: 'League Spartan',
                                          color: Color.fromARGB(255, 5, 106, 12
                                        ),),),
                                        Padding(padding: EdgeInsets.only(left: 2)),
                                        IconButton(
                                          alignment: Alignment.topCenter,
                                          onPressed: (){
                                          setState(() {
                                             amizadeProvider.aceitarPedidoAmizade(pedido.remetenteId, context.read<UserProvider>().user!.uid);
                                              amizadeProvider.fetchPedidosFromFirestore( context.read<UserProvider>().user!.uid);
                                               carregarTodosAmigos();
                                          });
                                         
                                        }, icon: Icon(Icons.check,color: Colors.green,)),
                                        Padding(padding: EdgeInsetsGeometry.only(left: 5)),
                                        IconButton(
                                          alignment: Alignment.topCenter,
                                          onPressed: (){
                                          setState(() {
                                             amizadeProvider.negarPedidoAmizade(pedido.remetenteId, context.read<UserProvider>().user!.uid);
                                             amizadeProvider.fetchPedidosFromFirestore( context.read<UserProvider>().user!.uid);
                                          });
                                         
                                        }, icon: Icon(Icons.close,color: Colors.red,)),
                                      ],
                                    ),
                                  ):Text( "Carregando... ");
                                },
                              ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}