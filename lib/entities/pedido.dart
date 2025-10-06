// model de pedido de amizade
class PedidoAmizade {

  // variáveis
  final String id;
  final String remetenteId;
  final String nomeRemetente;
  final String destinatario;
  final String status;
  final DateTime? dataCriacao;

  // construtor
  PedidoAmizade({
    required this.id,
    required this.remetenteId,
    required this.nomeRemetente,
    required this.destinatario,
    required this.status,
    this.dataCriacao,
  });
}
