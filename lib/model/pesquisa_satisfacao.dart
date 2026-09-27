class PesquisaSatisfacao {
  final int id;
  final int nota;
  final String? comentario;
  final String dataResposta;
  final int nutrizId;
  final String nutrizNome;
  final int doacaoId;

  PesquisaSatisfacao({
    required this.id,
    required this.nota,
    this.comentario,
    required this.dataResposta,
    required this.nutrizId,
    required this.nutrizNome,
    required this.doacaoId,
  });

  factory PesquisaSatisfacao.fromJson(Map<String, dynamic> json) {
    return PesquisaSatisfacao(
      id: json['id'],
      nota: json['nota'],
      comentario: json['comentario'],
      dataResposta: json['dataResposta'],
      nutrizId: json['nutrizId'],
      nutrizNome: json['nutrizNome'],
      doacaoId: json['doacaoId'],
    );
  }
}