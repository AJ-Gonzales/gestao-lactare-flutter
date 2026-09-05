class Agendamento {
  final int id;
  final String data;
  final String horario;
  final String status;
  final int nutrizId;
  final int bancoLeiteId;

  Agendamento({
    required this.id,
    required this.data,
    required this.horario,
    required this.status,
    required this.nutrizId,
    required this.bancoLeiteId,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      data: json['data'],
      horario: json['horario'],
      status: json['status'],
      nutrizId: json['nutrizId'],
      bancoLeiteId: json['bancoLeiteId'],
    );
  }
}