import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chamado_model.dart';
import 'auth_remote_datasource.dart';

class ChamadoRemoteDatasource {
  final http.Client _client;

  ChamadoRemoteDatasource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ChamadoModel>> buscarChamados(String token) async {
    final resposta = await _client.get(
      Uri.parse('${AuthRemoteDatasource.baseUrl}/chamados'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (resposta.statusCode == 200) {
      final corpo = jsonDecode(resposta.body);
      final lista = corpo['dados'] as List;
      return lista.map((item) => ChamadoModel.fromJson(item)).toList();
    }
    throw Exception('Erro ao buscar chamados');
  }
}