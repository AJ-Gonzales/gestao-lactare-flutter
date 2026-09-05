class BancoDeLeite {
  final int id;
  final String nome;
  final String endereco;
  final String cep;
  final String telefone;

  BancoDeLeite({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.cep,
    required this.telefone,
  });

  factory BancoDeLeite.fromJson(Map<String, dynamic> json) {
    return BancoDeLeite(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cep: json['cep'],
      telefone: json['telefone'],
    );
  }
}