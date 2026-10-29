import '../datasources/auth_remote_datasource.dart';
import '../datasources/token_storage_datasource.dart';
import '../models/usuario_model.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoto;
  final TokenStorageDatasource _storage;

  
  AuthRepository({
    AuthRemoteDatasource? remoto,
    TokenStorageDatasource? storage,
  })  : _remoto = remoto ?? AuthRemoteDatasource(),
        _storage = storage ?? TokenStorageDatasource();

  Future<UsuarioModel> fazerLogin(String email, String senha) async {
    final resposta = await _remoto.login(email, senha);
    await _storage.salvarToken(resposta.token);
    return resposta.usuario;
  }

  Future<bool> temSessao() async {
    final token = await _storage.lerToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> sair() async {
    await _storage.apagarToken();
  }
}