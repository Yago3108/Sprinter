import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/util/amigo.dart';
import 'package:myapp/util/pedido.dart';

class AmizadeProvider extends ChangeNotifier {
  final List<Amizade> _amizades = [];
  final List<PedidoAmizade> _pedidos = [];

  List<Amizade> get amizades =>_amizades;
  List<PedidoAmizade> get pedidos => _pedidos;
    bool verificarAmigo(String uid) {
    return _amizades.contains(uid);
  }
  // Buscar amizades do Firestore
  Future<void> fetchAmizadesFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('amizades')
        .get();

    _amizades.clear();
    for (var doc in snapshot.docs) {
      _amizades.add(Amizade(
        id: doc.id,
        usuarioId1: doc.id,
        usuarioId2: doc['uid'],
       
      ));
    }
    notifyListeners();
  }
  // Buscar pedidos de amizade do Firestore
  Future<void> fetchPedidosFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('pedidos')
        .get();

    _pedidos.clear();
    for (var doc in snapshot.docs) {
      _pedidos.add(PedidoAmizade(
        id: doc.id,
        remetenteId: doc['remetenteId'],
        nomeRemetente: doc['nomeRemetente'],
        destinatario: doc['destinatario'],
        status: doc['status'],
        dataCriacao: doc['dataCriacao']?.toDate(),
      ));
    }
    notifyListeners();
  }

  // Envia um pedido de amizade
  Future<void> enviarPedidoAmizade(String nomeRemetente,String uidRemetente, String uidDestinatario) async {
    final firestore = FirebaseFirestore.instance;

    // Cria um documento de pedido de amizade na subcoleção 'pedidos' do destinatário
    await firestore
        .collection('usuarios')
        .doc(uidDestinatario)
        .collection('pedidos')
        .doc(uidRemetente)
        .set({
      'remetenteId': uidRemetente,
      'nomeRemetente': nomeRemetente,
      'destinatario': uidDestinatario,
      'status': 'pendente',
      'dataCriacao': FieldValue.serverTimestamp(),
    });
  }

  // Aceita um pedido de amizade
  Future<void> aceitarPedidoAmizade(String uidRemetente, String uidDestinatario) async {
    final firestore = FirebaseFirestore.instance;
    _pedidos.removeWhere((pedido) => pedido.id == uidRemetente);
    // Adiciona amizade para ambos usuários
    await firestore
        .collection('usuarios')
        .doc(uidRemetente)
        .collection('amizades')
        .doc(uidDestinatario)
        .set({'uid': uidDestinatario, 'dataCriacao': FieldValue.serverTimestamp()});

    await firestore
        .collection('usuarios')
        .doc(uidDestinatario)
        .collection('amizades')
        .doc(uidRemetente)
        .set({'uid': uidRemetente, 'dataCriacao': FieldValue.serverTimestamp()});

    // Remove o pedido de amizade
    await firestore
        .collection('usuarios')
        .doc(uidDestinatario)
        .collection('pedidos')
        .doc(uidRemetente)
        .delete();
  }

  // Nega um pedido de amizade
  Future<void> negarPedidoAmizade(String uidRemetente, String uidDestinatario) async {
    final firestore = FirebaseFirestore.instance;

    // Remove o pedido de amizade
    await firestore
        .collection('usuarios')
        .doc(uidDestinatario)
        .collection('pedidos')
        .doc(uidRemetente)
        .delete();
  }
  void removerAmizade(String id) {
    
    _amizades.removeWhere((amizade) => amizade.id == id);
    notifyListeners();
  }

  void limparAmizades() {
    _amizades.clear();
    notifyListeners();
  }
}


