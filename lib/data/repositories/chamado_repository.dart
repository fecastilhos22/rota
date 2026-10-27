import '../datasources/chamado_remote_datasource.dart';
import '../datasources/database_helper.dart';
import '../datasources/token_storage_datasource.dart';
import '../models/chamado_model.dart';

class ChamadoRepository {
  final ChamadoRemoteDatasource _remoto;
  final DatabaseHelper _banco;
  final TokenStorageDatasource _storage;

  ChamadoRepository({
    ChamadoRemoteDatasource? remoto,
    DatabaseHelper? banco,
    TokenStorageDatasource? storage,
  })  : _remoto = remoto ?? ChamadoRemoteDatasource(),
        _banco = banco ?? DatabaseHelper.instance,
        _storage = storage ?? TokenStorageDatasource();

  Future<void> sincronizarChamados() async {
    final token = await _storage.lerToken();
    if (token == null) {
      throw Exception('Sem token');
    }
    final chamados = await _remoto.buscarChamados(token);
    for (final chamado in chamados) {
      await _banco.salvarChamado(chamado);
    }
  }

  Future<List<ChamadoModel>> listarChamadosAbertos() {
    return _banco.listarChamadosAbertos();
  }
}