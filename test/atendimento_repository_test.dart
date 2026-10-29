import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rota/data/datasources/atendimento_remote_datasource.dart';
import 'package:rota/data/datasources/database_helper.dart';
import 'package:rota/data/datasources/token_storage_datasource.dart';
import 'package:rota/data/models/atendimento_model.dart';
import 'package:rota/data/repositories/atendimento_repository.dart';

class MockBanco extends Mock implements DatabaseHelper {}

class MockRemoto extends Mock implements AtendimentoRemoteDatasource {}

class MockStorage extends Mock implements TokenStorageDatasource {}

AtendimentoModel _atendimento({int? id, int chamadoId = 7}) {
  return AtendimentoModel(
    id: id,
    chamadoId: chamadoId,
    categoriaTecnico: 'Cabo rompido',
    descricaoProcedimento: 'Troca do cabo externo',
    dataResolucao: '2026-10-01 10:00:00',
  );
}

void main() {
  late MockBanco banco;
  late MockRemoto remoto;
  late MockStorage storage;
  late AtendimentoRepository repository;

  setUpAll(() {
    registerFallbackValue(_atendimento());
  });

  setUp(() {
    banco = MockBanco();
    remoto = MockRemoto();
    storage = MockStorage();
    repository = AtendimentoRepository(banco: banco, remoto: remoto, storage: storage);
  });

  test('concluirAtendimento salva o atendimento e marca o chamado como atendido', () async {
    when(() => banco.salvarAtendimento(any())).thenAnswer((_) async => 1);
    when(() => banco.marcarChamadoComoAtendido(7)).thenAnswer((_) async {});

    await repository.concluirAtendimento(_atendimento());

    verify(() => banco.salvarAtendimento(any())).called(1);
    verify(() => banco.marcarChamadoComoAtendido(7)).called(1);
  });

  test('sincronizarPendentes envia e marca como sincronizado', () async {
    when(() => storage.lerToken()).thenAnswer((_) async => 'tok');
    when(() => banco.listarAtendimentosPendentes())
        .thenAnswer((_) async => [_atendimento(id: 5)]);
    when(() => remoto.enviar('tok', any())).thenAnswer((_) async => 'https://foto.jpg');
    when(() => banco.marcarAtendimentoSincronizado(5, fotoUrl: 'https://foto.jpg'))
        .thenAnswer((_) async {});

    final enviados = await repository.sincronizarPendentes();

    expect(enviados, 1);
    verify(() => banco.marcarAtendimentoSincronizado(5, fotoUrl: 'https://foto.jpg')).called(1);
  });

  test('se o envio falhar, o atendimento continua pendente', () async {
    when(() => storage.lerToken()).thenAnswer((_) async => 'tok');
    when(() => banco.listarAtendimentosPendentes())
        .thenAnswer((_) async => [_atendimento(id: 5)]);
    when(() => remoto.enviar('tok', any())).thenThrow(Exception('sem internet'));

    expect(() => repository.sincronizarPendentes(), throwsException);
    verifyNever(() => banco.marcarAtendimentoSincronizado(5, fotoUrl: any(named: 'fotoUrl')));
  });

  test('sem atendimentos pendentes devolve zero', () async {
    when(() => storage.lerToken()).thenAnswer((_) async => 'tok');
    when(() => banco.listarAtendimentosPendentes()).thenAnswer((_) async => []);

    expect(await repository.sincronizarPendentes(), 0);
  });
}