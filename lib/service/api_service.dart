import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1';

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception('Erro ao buscar dados: ${response.statusCode}');
  }

  Future<dynamic> patch(String endpoint) async {
    final response = await http.patch(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Erro ao atualizar dados: ${response.statusCode} - ${response.body}',
    );
  }
}
