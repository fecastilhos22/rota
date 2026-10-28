import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/atendimento_model.dart';
import 'auth_remote_datasource.dart';

 class AtendimentoRemoteDatasource {
  Future<String?> enviar(String token, AtendimentoModel atendimento) async {
    final requisicao = http.MultipartRequest(
      'POST',
      Uri.parse('${AuthRemoteDatasource.baseUrl}/atendimento'),
    );

    requisicao.headers['Authorization'] = 'Bearer $token';

    atendimento.toJson().forEach((chave, valor) {
      requisicao.fields[chave] = valor.toString();
    });

    final caminho = atendimento.caminhoFoto;
    if (caminho != null && File(caminho).existsSync()) {
      requisicao.files.add(await http.MultipartFile.fromPath('foto', caminho));
    }

    final enviada = await requisicao.send();
    final resposta = await http.Response.fromStream(enviada);

    if (resposta.statusCode == 201 || resposta.statusCode == 200) {
      final corpo = jsonDecode(resposta.body);
      return corpo['dados']['foto_url'];
    }
    throw Exception('Erro ao enviar atendimento');
  }
}