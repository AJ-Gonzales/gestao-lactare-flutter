import 'package:gestao_lactare/service/api_service.dart';

import '../model/pesquisa_satisfacao.dart';

class PesquisaSatisfacaoService {
  final ApiService apiService;

  PesquisaSatisfacaoService(this.apiService);

  Future<List<PesquisaSatisfacao>> buscarPesquisas() async {
    final dados = await apiService.get('/pesquisas');

    return (dados as List)
        .map((json) => PesquisaSatisfacao.fromJson(json))
        .toList();
  }
}