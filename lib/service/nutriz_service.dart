import 'package:gestao_lactare/model/nutriz.dart';
import 'package:gestao_lactare/service/api_service.dart';

class NutrizService {
  final ApiService apiService;

  NutrizService(this.apiService);

  Future<List<Nutriz>> buscarNutrizes() async {
    final dados = await apiService.get('/nutrizes');

    return (dados as List).map((json) => Nutriz.fromJson(json)).toList();
  }

  Future<Nutriz> buscarPorId(int id) async {
    final dados = await apiService.get('/nutrizes/$id');

    return Nutriz.fromJson(dados);
  }
}
