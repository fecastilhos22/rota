import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rota/data/datasources/auth_remote_datasource.dart';
import 'package:rota/data/datasources/token_storage_datasource.dart';
import 'package:rota/data/models/usuario_model.dart';
import 'package:rota/data/repositories/auth_repository.dart';

class MockRemoto extends Mock implements AuthRemoteDatasource {}

class MockStorage extends Mock implements TokenStorageDatasource {}

void main() {
  late MockRemoto remoto;
  late MockStorage storage;
  late AuthRepository repository;

  setUp(() {
    remoto = MockRemoto();
    storage = MockStorage();
    repository = AuthRepository(remoto: remoto, storage: storage);
  });

  test('fazerLogin salva o token e devolve o usuario', () async {
    final usuario = UsuarioModel(id: 1, nome: 'Tecnico', email: 'tec@teste.com');
    when(() => remoto.login('tec@teste.com', '123'))
        .thenAnswer((_) async => LoginResposta(token: 'tok', usuario: usuario));
    when(() => storage.salvarToken('tok')).thenAnswer((_) async {});

    final resultado = await repository.fazerLogin('tec@teste.com', '123');

    expect(resultado.nome, 'Tecnico');
    verify(() => storage.salvarToken('tok')).called(1);
  });

  test('temSessao e true quando existe token', () async {
    when(() => storage.lerToken()).thenAnswer((_) async => 'tok');
    expect(await repository.temSessao(), true);
  });

  test('temSessao e false quando nao existe token', () async {
    when(() => storage.lerToken()).thenAnswer((_) async => null);
    expect(await repository.temSessao(), false);
  });

  test('sair apaga o token', () async {
    when(() => storage.apagarToken()).thenAnswer((_) async {});
    await repository.sair();
    verify(() => storage.apagarToken()).called(1);
  });
}