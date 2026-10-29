import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rota/data/datasources/chamado_remote_datasource.dart';

void main() {
  final chamadoJson = {
    'id': 1,
    'codigo_cliente': 'CLI-1',
    'nome_cliente': 'Maria',
    'categoria_informada': 'Lentidao',
    'descricao_problema': 'Internet lenta',
    'endereco_cliente': 'Rua A, 10',
    'bairro': 'Centro',
    'cidade': 'Chapeco',
    'latitude': -27.1,
    'longitude': -52.6,
    'status': 'ativo',
    'criado_em': '2026-09-28 14:20:00',
  };

  test('busca chamados com o token e converte para models', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer token123');
      expect(request.url.path, '/api/chamados');
      return http.Response(
        jsonEncode({'sucesso': true, 'dados': [chamadoJson]}),
        200,
      );
    });

    final ds = ChamadoRemoteDatasource(client: client);
    final lista = await ds.buscarChamados('token123');

    expect(lista.length, 1);
    expect(lista.first.codigoCliente, 'CLI-1');
    expect(lista.first.status, 'aberto');
  });

  test('erro da API vira Exception', () async {
    final client = MockClient((request) async => http.Response('erro', 500));
    final ds = ChamadoRemoteDatasource(client: client);

    expect(() => ds.buscarChamados('x'), throwsException);
  });
}