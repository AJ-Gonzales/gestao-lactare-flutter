import 'package:gestao_lactare/model/banco_de_leite.dart';
import 'package:gestao_lactare/service/api_service.dart';

class BancoLeiteService {
  final ApiService apiService;

  BancoLeiteService(this.apiService);

  Future<List<BancoDeLeite>> buscarBancosDeLeite() async {
    final dados = await apiService.get('/bancos-de-leite');

    return (dados as List)
        .map((json) => BancoDeLeite.fromJson(json))
        .toList();
  }
}