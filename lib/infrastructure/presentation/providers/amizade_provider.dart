import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/entities/amigo.dart';
import 'package:myapp/entities/amizade.dart';
import 'package:myapp/entities/pedido.dart';

class AmizadeProvider extends ChangeNotifier {
  
  // listas de amizades e pedidos
  final List<Amizade> _amizades = [];
  final List<PedidoAmizade> _pedidos = [];
  final List<Amigo>_amigos=[];
  // getter para as listas
  List<Amizade> get amizades =>_amizades;
  List<PedidoAmizade> get pedidos => _pedidos;
  List<Amigo> get amigos=>_amigos;

  // verifica se é amigo
  bool verificarAmigo(String uid) {
    return _amizades.any((amizade) =>
    amizade.usuarioId1 == uid || amizade.usuarioId2 == uid);
  }

  // buscar amizades do firestore
  Future<void> fetchAmizadesFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('amizades')
        .get();

    // limpa a lista antes de adicionar as amizades
    _amizades.clear();
    for (var doc in snapshot.docs) {
      amizades.add(Amizade(
        id: doc.id,
        usuarioId1: doc.id,
        usuarioId2: doc['uid'],
      ));
    }
      for (var doc in snapshot.docs) {
      amigos.add(Amigo(
        uid: doc['uid'],
        dataInicio: doc['dataCriacao'].toDate(),
      ));
    }
    notifyListeners();
  }

  // buscar pedidos de amizade do firestore
  Future<void> fetchPedidosFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('pedidos')
        .get();

    // limpa a lista antes de adicionar os pedidos de amizade
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

  // envia um pedido de amizade
  Future<void> enviarPedidoAmizade(String nomeRemetente,String uidRemetente, String uidDestinatario) async {
    final firestore = FirebaseFirestore.instance;

    // cria um documento de pedido de amizade na subcoleção 'pedidos' do destinatário
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

  // aceita um pedido de amizade
  Future<void> aceitarPedidoAmizade(String uidRemetente, String uidDestinatario) async {
    final firestore = FirebaseFirestore.instance;

    // remove o pedido
    _pedidos.removeWhere((pedido) => pedido.id == uidRemetente);

    // adiciona amizade para ambos usuários
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

    // remove o pedido de amizade
    await firestore
        .collection('usuarios')
        .doc(uidDestinatario)
        .collection('pedidos')
        .doc(uidRemetente)
        .delete();
  }

  // nega um pedido de amizade
  Future<void> negarPedidoAmizade(String uidRemetente, String uidDestinatario) async {
    final firestore = FirebaseFirestore.instance;

    // remove o pedido de amizade
    await firestore
        .collection('usuarios')
        .doc(uidDestinatario)
        .collection('pedidos')
        .doc(uidRemetente)
        .delete();
  }

  // remove a amizade
  void removerAmizade(String id) {
    _amizades.removeWhere((amizade) => amizade.id == id);
    notifyListeners();
  }

  // limpa as amizades
  void limparAmizades() {
    _amizades.clear();
    notifyListeners();
  }
}


