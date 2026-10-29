import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rota/data/datasources/chamado_remote_datasource.dart';
import 'package:rota/data/datasources/database_helper.dart';
import 'package:rota/data/datasources/localizacao_datasource.dart';
import 'package:rota/data/datasources/token_storage_datasource.dart';
import 'package:rota/data/models/chamado_model.dart';
import 'package:rota/data/repositories/chamado_repository.dart';

class MockRemoto extends Mock implements ChamadoRemoteDatasource {}

class MockBanco extends Mock implements DatabaseHelper {}

class MockStorage extends Mock implements TokenStorageDatasource {}

class MockLocalizacao extends Mock implements LocalizacaoDatasource {}

class MockPosition extends Mock implements Position {}

ChamadoModel _chamado(int id, double latitude) {
  return ChamadoModel(
    id: id,
    codigoCliente: 'CLI-$id',
    nomeCliente: 'Cliente $id',
    categoriaInformada: 'Lentidao',
    descricaoProblema: 'Teste',
    enderecoCliente: 'Rua $id',
    bairro: 'Centro',
    cidade: 'Chapeco',
    latitude: latitude,
    longitude: 0,
    criadoEm: '2026-10-01 10:00:00',
    status: 'aberto',
  );
}

void main() {
  late MockRemoto remoto;
  late MockBanco banco;
  late MockStorage storage;
  late MockLocalizacao localizacao;
  late ChamadoRepository repository;

  setUpAll(() {
    registerFallbackValue(_chamado(0, 0));
  });

  setUp(() {
    remoto = MockRemoto();
    banco = MockBanco();
    storage = MockStorage();
    localizacao = MockLocalizacao();
    repository = ChamadoRepository(
      remoto: remoto,
      banco: banco,
      storage: storage,
      localizacao: localizacao,
    );
  });

  group('sincronizarChamados', () {
    test('baixa da API e salva cada chamado no banco', () async {
      when(() => storage.lerToken()).thenAnswer((_) async => 'tok');
      when(() => remoto.buscarChamados('tok'))
          .thenAnswer((_) async => [_chamado(1, 1), _chamado(2, 2)]);
      when(() => banco.salvarChamado(any())).thenAnswer((_) async {});

      await repository.sincronizarChamados();

      verify(() => banco.salvarChamado(any())).called(2);
    });

    test('sem token lanca Exception', () async {
      when(() => storage.lerToken()).thenAnswer((_) async => null);

      expect(() => repository.sincronizarChamados(), throwsException);
    });
  });

  group('listarChamadosPorProximidade', () {
    test('ordena do mais perto ao mais longe', () async {
      final perto = _chamado(1, 2);
      final longe = _chamado(2, 10);
      final posicao = MockPosition();
      when(() => posicao.latitude).thenReturn(0);
      when(() => posicao.longitude).thenReturn(0);

      // O banco devolve o mais longe primeiro, de proposito
      when(() => banco.listarChamadosAbertos()).thenAnswer((_) async => [longe, perto]);
      when(() => localizacao.buscarPosicaoAtual()).thenAnswer((_) async => posicao);
      // Distancia falsa: usa a propria latitude do chamado
      when(() => localizacao.calcularDistanciaKm(any(), any(), any(), any()))
          .thenAnswer((invocacao) => (invocacao.positionalArguments[2] as double).abs());

      final lista = await repository.listarChamadosPorProximidade();

      expect(lista.first.id, 1);
      expect(lista.last.id, 2);
      expect(lista.first.distanciaKm, 2);
    });

    test('sem GPS devolve a lista sem distancia', () async {
      when(() => banco.listarChamadosAbertos()).thenAnswer((_) async => [_chamado(1, 5)]);
      when(() => localizacao.buscarPosicaoAtual()).thenAnswer((_) async => null);

      final lista = await repository.listarChamadosPorProximidade();

      expect(lista.length, 1);
      expect(lista.first.distanciaKm, isNull);
    });
  });
}