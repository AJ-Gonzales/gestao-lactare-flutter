class Nutriz {
  final int id;
  final String nome;
  final String cpf;
  final String telefone;
  final String? email;
  final String dataNascimento;
  final String endereco;
  final String cep;

  Nutriz({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    this.email,
    required this.dataNascimento,
    required this.endereco,
    required this.cep,
  });

  factory Nutriz.fromJson(Map<String, dynamic> json) {
    return Nutriz(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      email: json['email'],
      dataNascimento: json['dataNascimento'],
      endereco: json['endereco'],
      cep: json['cep'],
    );
  }
}
