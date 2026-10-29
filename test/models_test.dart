import 'package:flutter_test/flutter_test.dart';
import 'package:rota/data/models/atendimento_model.dart';
import 'package:rota/data/models/chamado_model.dart';
import 'package:rota/data/models/usuario_model.dart';

void main() {
  final Map<String, dynamic> jsonChamado = {
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

  group('ChamadoModel', () {
    test('fromJson converte o status ativo em aberto', () {
      final chamado = ChamadoModel.fromJson(jsonChamado);
      expect(chamado.status, 'aberto');
      expect(chamado.codigoCliente, 'CLI-1');
    });

    test('fromJson aceita latitude em texto', () {
      final chamado = ChamadoModel.fromJson({...jsonChamado, 'latitude': '-27.1'});
      expect(chamado.latitude, -27.1);
    });

    test('toMap e fromMap mantem os dados', () {
      final original = ChamadoModel.fromJson(jsonChamado);
      final copia = ChamadoModel.fromMap(original.toMap());
      expect(copia.id, original.id);
      expect(copia.nomeCliente, original.nomeCliente);
      expect(copia.status, 'aberto');
    });

    test('marcarComoAtendido muda o status', () {
      final chamado = ChamadoModel.fromJson(jsonChamado);
      chamado.marcarComoAtendido();
      expect(chamado.status, 'atendido');
    });

    test('enderecoCompleto junta endereco, bairro e cidade', () {
      final chamado = ChamadoModel.fromJson(jsonChamado);
      expect(chamado.enderecoCompleto, 'Rua A, 10 - Centro, Chapeco');
    });
  });

  group('AtendimentoModel', () {
    test('comeca como pendente (sincronizado = 0)', () {
      final atendimento = AtendimentoModel(
        chamadoId: 1,
        categoriaTecnico: 'Cabo rompido',
        descricaoProcedimento: 'Troca do cabo externo',
        dataResolucao: '2026-10-01 10:00:00',
      );
      expect(atendimento.sincronizado, 0);
    });

    test('toJson tem os campos que a API pede', () {
      final atendimento = AtendimentoModel(
        chamadoId: 3,
        categoriaTecnico: 'Cabo rompido',
        descricaoProcedimento: 'Troca do cabo externo',
        dataResolucao: '2026-10-01 10:00:00',
      );
      final json = atendimento.toJson();
      expect(json['chamado_id'], 3);
      expect(json['categoria_tecnico'], 'Cabo rompido');
      expect(json.containsKey('descricao_procedimento'), true);
      expect(json.containsKey('data_resolucao'), true);
    });

    test('toMap e fromMap mantem os dados', () {
      final original = AtendimentoModel(
        id: 9,
        chamadoId: 3,
        categoriaTecnico: 'Sinal fraco',
        descricaoProcedimento: 'Ajuste da antena',
        dataResolucao: '2026-10-01 10:00:00',
        caminhoFoto: '/foto.jpg',
      );
      final copia = AtendimentoModel.fromMap(original.toMap());
      expect(copia.id, 9);
      expect(copia.caminhoFoto, '/foto.jpg');
      expect(copia.sincronizado, 0);
    });

    test('fromJson do historico marca como sincronizado', () {
      final atendimento = AtendimentoModel.fromJson({
        'id': 14,
        'categoria_tecnico': 'Conector danificado',
        'descricao_procedimento': 'Nova conectorizacao',
        'data_resolucao': '2026-10-01 15:30:00',
        'foto_url': 'https://exemplo.com/foto.jpg',
      }, 1);
      expect(atendimento.sincronizado, 1);
      expect(atendimento.fotoUrl, 'https://exemplo.com/foto.jpg');
    });
  });

  group('UsuarioModel', () {
    test('toMap e fromMap mantem os dados', () {
      final usuario = UsuarioModel(id: 1, nome: 'Tecnico', email: 'tec@teste.com');
      final copia = UsuarioModel.fromMap(usuario.toMap());
      expect(copia.nome, 'Tecnico');
      expect(copia.email, 'tec@teste.com');
    });
  });
}