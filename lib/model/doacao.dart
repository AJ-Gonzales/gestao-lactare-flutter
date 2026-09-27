class Doacao {
  final int id;
  final String data;
  final double quantidade;
  final int nutrizId;
  final String nutrizNome;
  final int bancoLeiteId;
  final String bancoLeiteNome;
  final int agendamentoId;

  Doacao({
    required this.id,
    required this.data,
    required this.quantidade,
    required this.nutrizId,
    required this.nutrizNome,
    required this.bancoLeiteId,
    required this.bancoLeiteNome,
    required this.agendamentoId,
  });

  factory Doacao.fromJson(Map<String, dynamic> json) {
    return Doacao(
      id: json['id'],
      data: json['data'],
      quantidade: (json['quantidade'] as num).toDouble(),
      nutrizId: json['nutrizId'],
      nutrizNome: json['nutrizNome'],
      bancoLeiteId: json['bancoLeiteId'],
      bancoLeiteNome: json['bancoLeiteNome'],
      agendamentoId: json['agendamentoId'],
    );
  }
}
