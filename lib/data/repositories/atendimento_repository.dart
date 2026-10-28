import '../datasources/atendimento_remote_datasource.dart';
import '../datasources/database_helper.dart';
import '../datasources/token_storage_datasource.dart';
import '../models/atendimento_model.dart';

class AtendimentoRepository {
  final DatabaseHelper _banco;
  final AtendimentoRemoteDatasource _remoto;
  final TokenStorageDatasource _storage;

  AtendimentoRepository({
    DatabaseHelper? banco,
    AtendimentoRemoteDatasource? remoto,
    TokenStorageDatasource? storage,
  })  : _banco = banco ?? DatabaseHelper.instance,
        _remoto = remoto ?? AtendimentoRemoteDatasource(),
        _storage = storage ?? TokenStorageDatasource();

  Future<void> concluirAtendimento(AtendimentoModel atendimento) async {
    await _banco.salvarAtendimento(atendimento);
    await _banco.marcarChamadoComoAtendido(atendimento.chamadoId);
  }

  // Envia todos os pendentes. Devolve quantos foram enviados
  Future<int> sincronizarPendentes() async {
    final token = await _storage.lerToken();
    if (token == null) {
      throw Exception('Sem token');
    }

    final pendentes = await _banco.listarAtendimentosPendentes();
    int enviados = 0;
    int falhas = 0;

    for (final atendimento in pendentes) {
      try {
        final fotoUrl = await _remoto.enviar(token, atendimento);
        await _banco.marcarAtendimentoSincronizado(atendimento.id!, fotoUrl: fotoUrl);
        enviados++;
      } catch (e) {
        falhas++;
      }
    }

    if (falhas > 0 && enviados == 0) {
      throw Exception('Falha ao enviar');
    }
    return enviados;
  }
}