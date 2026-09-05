import 'package:gestao_lactare/service/api_service.dart';

import '../model/doacao.dart';

class DoacaoService {
  final ApiService apiService;

  DoacaoService(this.apiService);

  Future<List<Doacao>> buscarDoacoes() async {
    final dados = await apiService.get('/doações');

    return (dados as List)
    .map((json) => Doacao.fromJson(json))
    .toList();
  }
}
