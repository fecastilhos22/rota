import 'package:flutter/material.dart';
import '../data/datasources/foto_datasource.dart';
import '../data/models/atendimento_model.dart';
import '../data/repositories/atendimento_repository.dart';

class AtendimentoViewModel extends ChangeNotifier {
  final AtendimentoRepository _repository;
  final FotoDatasource _foto;

  AtendimentoViewModel({
    AtendimentoRepository? repository,
    FotoDatasource? foto,
  })  : _repository = repository ?? AtendimentoRepository(),
        _foto = foto ?? FotoDatasource();

  String? caminhoFoto;
  bool salvando = false;

  final List<String> categorias = [
    'Conector danificado',
    'Cabo rompido',
    'Configuração do roteador',
    'Troca de equipamento',
    'Sinal fraco',
    'Resolvido remotamente',
  ];

  Future<void> escolherFoto({required bool usarCamera}) async {
    final caminho = await _foto.capturarESalvar(usarCamera: usarCamera);
    if (caminho != null) {
      caminhoFoto = caminho;
      notifyListeners();
    }
  }

  String _doisDigitos(int n) => n.toString().padLeft(2, '0');

  String _formatarData(DateTime d) {
    return '${d.year}-${_doisDigitos(d.month)}-${_doisDigitos(d.day)} '
        '${_doisDigitos(d.hour)}:${_doisDigitos(d.minute)}:${_doisDigitos(d.second)}';
  }

  // Devolve true se salvou com sucesso
  Future<bool> concluir({
    required int chamadoId,
    required String categoria,
    required String descricao,
    required DateTime data,
  }) async {
    salvando = true;
    notifyListeners();

    try {
      final agora = DateTime.now();
      final dataCompleta = DateTime(
        data.year, data.month, data.day, agora.hour, agora.minute, agora.second,
      );

      final atendimento = AtendimentoModel(
        chamadoId: chamadoId,
        categoriaTecnico: categoria,
        descricaoProcedimento: descricao.trim(),
        dataResolucao: _formatarData(dataCompleta),
        caminhoFoto: caminhoFoto,
      );
      await _repository.concluirAtendimento(atendimento);
      salvando = false;
      notifyListeners();
      return true;
    } catch (e) {
      salvando = false;
      notifyListeners();
      return false;
    }
  }
}