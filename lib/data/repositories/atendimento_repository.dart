import '../datasources/database_helper.dart';
import '../models/atendimento_model.dart';

class AtendimentoRepository {
  final DatabaseHelper _banco;

  AtendimentoRepository({DatabaseHelper? banco})
      : _banco = banco ?? DatabaseHelper.instance;

  Future<void> concluirAtendimento(AtendimentoModel atendimento) async {
    await _banco.salvarAtendimento(atendimento);
    await _banco.marcarChamadoComoAtendido(atendimento.chamadoId);
  }
}