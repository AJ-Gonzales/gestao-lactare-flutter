class Nutriz {
  final int id;
  final String nome;
  final String cpf;
  final String telefone;
  final String? email;

  Nutriz({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    this.email,
  });

  factory Nutriz.fromJson(Map<String, dynamic> json) {
    return Nutriz(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }
}
