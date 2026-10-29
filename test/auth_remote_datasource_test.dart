import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rota/data/datasources/auth_remote_datasource.dart';

void main() {
  group('gerarHmac', () {
    test('devolve 64 caracteres hexadecimais', () {
      final hmac = AuthRemoteDatasource().gerarHmac('minhaSenha123');
      expect(hmac.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(hmac), true);
    });

    test('mesma senha gera o mesmo resultado, senhas diferentes geram resultados diferentes', () {
      final ds = AuthRemoteDatasource();
      expect(ds.gerarHmac('abc'), ds.gerarHmac('abc'));
      expect(ds.gerarHmac('abc'), isNot(ds.gerarHmac('abd')));
    });
  });

  group('login', () {
    test('envia o HMAC (nunca a senha pura) e devolve token e usuario', () async {
      final client = MockClient((request) async {
        final corpo = jsonDecode(request.body);
        expect(request.url.path, '/api/login');
        expect(corpo['email'], 'tec@teste.com');
        expect(corpo['senha_hmac'], AuthRemoteDatasource().gerarHmac('minhaSenha123'));
        expect(request.body.contains('minhaSenha123'), false);

        return http.Response(
          jsonEncode({
            'sucesso': true,
            'mensagem': 'ok',
            'dados': {
              'token': 'abc123',
              'usuario': {'id': 1, 'nome': 'Tecnico', 'email': 'tec@teste.com'},
            },
          }),
          200,
        );
      });

      final ds = AuthRemoteDatasource(client: client);
      final resposta = await ds.login('tec@teste.com', 'minhaSenha123');

      expect(resposta.token, 'abc123');
      expect(resposta.usuario.nome, 'Tecnico');
    });

    test('credenciais invalidas viram Exception com a mensagem da API', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({'sucesso': false, 'mensagem': 'Credenciais invalidas'}),
          401,
        );
      });

      final ds = AuthRemoteDatasource(client: client);

      expect(
        () => ds.login('tec@teste.com', 'errada'),
        throwsA(predicate((e) => e.toString().contains('Credenciais invalidas'))),
      );
    });
  });
}