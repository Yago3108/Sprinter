import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WidgetPesquisaUsuario extends StatefulWidget {
  final void Function(String produtoId) onProdutoSelecionado;

  const WidgetPesquisaUsuario({
    super.key,
    required this.onProdutoSelecionado,
  });
  @override
  WidgetPesquisaUsuarioState createState() => WidgetPesquisaUsuarioState();
}

class WidgetPesquisaUsuarioState extends State<WidgetPesquisaUsuario> {
    OverlayEntry? _overlayEntry;
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hint: Text("Pesquisar usuário..."),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color:Color.fromARGB(255, 5, 106, 12), width: 1.5),
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value.trim();
              });
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: (query.isEmpty)
                ? FirebaseFirestore.instance
                      .collection('usuarios')
                      .limit(3) // mostra 3 primeiros sem filtro
                      .snapshots()
                : FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('nome', isGreaterThanOrEqualTo: query)
                      .where('nome', isLessThanOrEqualTo: query + '\uf8ff')
                      .limit(3)
                      .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final usuarios = snapshot.data!.docs;

              if (usuarios.isEmpty) {
                return const Center(child: Text("Nenhum usuário encontrado"));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return ListTile(
                    title: Text(usuario['nome']),
                    onTap: () {
                    widget.onProdutoSelecionado(usuario.id);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
  
    void _removerPesquisa() {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
}
