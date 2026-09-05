import 'package:gestao_lactare/service/api_service.dart';
import '../model/agendamento.dart';

class AgendamentoService {
  final ApiService apiService;

  AgendamentoService(this.apiService);

  Future<List<Agendamento>> buscarAgendamentos() async {
    final dados = await apiService.get('/agendamentos');

    return (dados as List)
        .map((json) => Agendamento.fromJson(json))
        .toList();
  }
}