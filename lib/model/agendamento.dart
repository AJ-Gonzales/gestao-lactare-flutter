class Agendamento {
  final int id;
  final String data;
  final String horario;
  final String status;
  final int nutrizId;
  final String nutrizNome;
  final int bancoLeiteId;
  final String bancoLeiteNome;

  Agendamento({
    required this.id,
    required this.data,
    required this.horario,
    required this.status,
    required this.nutrizId,
    required this.nutrizNome,
    required this.bancoLeiteId,
    required this.bancoLeiteNome,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      data: json['data'],
      horario: json['horario'],
      status: json['status'],
      nutrizId: json['nutrizId'],
      nutrizNome: json['nutrizNome'],
      bancoLeiteId: json['bancoLeiteId'],
      bancoLeiteNome: json['bancoLeiteNome'],
    );
  }
}