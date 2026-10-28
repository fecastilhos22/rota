import '../datasources/chamado_remote_datasource.dart';
import '../datasources/database_helper.dart';
import '../datasources/localizacao_datasource.dart';
import '../datasources/token_storage_datasource.dart';
import '../models/chamado_model.dart';

class ChamadoRepository {
  final ChamadoRemoteDatasource _remoto;
  final DatabaseHelper _banco;
  final TokenStorageDatasource _storage;
  final LocalizacaoDatasource _localizacao;

  ChamadoRepository({
    ChamadoRemoteDatasource? remoto,
    DatabaseHelper? banco,
    TokenStorageDatasource? storage,
    LocalizacaoDatasource? localizacao,
  })  : _remoto = remoto ?? ChamadoRemoteDatasource(),
        _banco = banco ?? DatabaseHelper.instance,
        _storage = storage ?? TokenStorageDatasource(),
        _localizacao = localizacao ?? LocalizacaoDatasource();

 
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

 
  Future<List<ChamadoModel>> listarChamadosPorProximidade() async {
    final chamados = await _banco.listarChamadosAbertos();
    final posicao = await _localizacao.buscarPosicaoAtual();

   
    if (posicao == null) return chamados;

    for (final chamado in chamados) {
      chamado.distanciaKm = _localizacao.calcularDistanciaKm(
        posicao.latitude,
        posicao.longitude,
        chamado.latitude,
        chamado.longitude,
      );
    }

    chamados.sort((a, b) => a.distanciaKm!.compareTo(b.distanciaKm!));
    return chamados;
  }
}