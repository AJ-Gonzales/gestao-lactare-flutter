import 'package:gestao_lactare/model/agendamento.dart';
import 'package:gestao_lactare/service/api_service.dart';

class AgendamentoService {
  final ApiService apiService;

  AgendamentoService(this.apiService);

  Future<List<Agendamento>> buscarAgendamentos() async {
    final dados = await apiService.get('/agendamentos');

    return (dados as List).map((json) => Agendamento.fromJson(json)).toList();
  }

  Future<Agendamento> atualizarStatus(int id, String status) async {
    final dados = await apiService.patch(
      '/agendamentos/$id/status?status=$status',
    );

    return Agendamento.fromJson(dados);
  }
}
