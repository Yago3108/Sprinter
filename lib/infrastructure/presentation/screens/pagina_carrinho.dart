import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/widget_produto_carrinho.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil.dart';
import 'package:provider/provider.dart';

class PaginaCarrinho extends StatefulWidget {
  const PaginaCarrinho({super.key});

  @override
  State<PaginaCarrinho> createState() => _PaginaCarrinhoState();
}

class _PaginaCarrinhoState extends State<PaginaCarrinho> {
  // Mantém a lógica de inicialização segura
  late Future<List<WidgetProdutoCarrinho>> _comprasFuture;
  bool _isFutureInitialized = false; 
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Inicializa o Future apenas na primeira vez
    if (!_isFutureInitialized) {
        _initializeFuture(); 
    }
  }

  void _initializeFuture() {
    final userProvider = context.read<UserProvider>();
    final produtoProvider = context.read<ProdutoProvider>();
    final userId = userProvider.user!.uid;
    _comprasFuture = produtoProvider.carregarTodasAsCompras(userId); 
    _isFutureInitialized = true;
   
         
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user!.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
      try {
        bytes = base64Decode(fotoBase64);
      } catch (_) { /* Ignora */ }
    }

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        backgroundColor: const Color.fromARGB(255, 5, 106, 12),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>const Pagina(key: null,)));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: bytes != null
                  ? MemoryImage(bytes)
                  : const AssetImage("assets/images/perfil_basico.jpg") as ImageProvider,
              radius: 25,
            ),
            onPressed: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PaginaPerfil()),
              ),
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
        
          Padding(
            padding: EdgeInsets.only(right: 15, left: 15),

            child: Text(
              "Seus Ingressos",
              style: TextStyle(
                fontSize: 28,
                fontFamily: "League Spartan",
                fontWeight:FontWeight.w900,
                color: const Color.fromARGB(255, 5, 106, 12)
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          
 
            Expanded( 
            child: FutureBuilder<List<WidgetProdutoCarrinho>>(
              future: _comprasFuture,
              builder: (context, snapshot) {
                // 1. Carregando
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Erro
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Erro ao carregar compras: ${snapshot.error}", textAlign: TextAlign.center),
                    ),
                  );
                }

                // 3. Dados Carregados
                final List<WidgetProdutoCarrinho> produtosComprados = snapshot.data ?? [];

                // 4. CÁLCULO DOS TOTAIS: usando a length da lista de widgets
                final int totalCompras = produtosComprados.length;
                
                // NOTA: totalIngressos (soma das quantidades) é 0 pois o dado está no widget
                // Se você precisar da soma das quantidades, o Provider DEVE retornar List<Compra>.
                const int totalIngressos = 0; 

                // 5. Exibição: Container de Totais + Lista de Widgets
                return Column(
                  children: [
                    // CONTAINER DE TOTAIS
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 230, 255, 230), 
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color.fromARGB(255, 5, 106, 12), width: 1.5),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("aaa")
                          ],
                      ),
                    ),
                    
                    // Lista de Widgets (deve estar Expandida dentro deste Column)
                    Expanded(
                        child: produtosComprados.isEmpty
                            ? const Center(child: Text("Nenhuma compra encontrada.", style: TextStyle(fontSize: 18)))
                            : ListView(
                                children: produtosComprados,
                                padding: EdgeInsets.zero, // Remove padding padrão do ListView
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}