class Doacao {
  final int id;
  final String data;
  final double quantidade;
  final int nutrizId;
  final int bancoLeiteId;
  final int agendamentoId;

  Doacao({
    required this.id,
    required this.data,
    required this.quantidade,
    required this.nutrizId,
    required this.bancoLeiteId,
    required this.agendamentoId,
  });

  factory Doacao.fromJson(Map<String, dynamic> json) {
    return Doacao(
      id: json['id'],
      data: json['data'],
      quantidade: (json['quantidade'] as num).toDouble(),
      nutrizId: json['nutrizId'],
      bancoLeiteId: json['bancoLeiteId'],
      agendamentoId: json['agendamentoId'],
    );
  }
}
