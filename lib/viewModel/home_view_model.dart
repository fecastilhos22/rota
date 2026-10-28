import 'package:flutter/material.dart';
import '../data/models/chamado_model.dart';
import '../data/repositories/atendimento_repository.dart';
import '../data/repositories/chamado_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ChamadoRepository _repository;
  final AtendimentoRepository _atendimentoRepository;

  HomeViewModel({
    ChamadoRepository? repository,
    AtendimentoRepository? atendimentoRepository,
  })  : _repository = repository ?? ChamadoRepository(),
        _atendimentoRepository = atendimentoRepository ?? AtendimentoRepository();

  List<ChamadoModel> chamados = [];
  bool carregando = false;
  bool offline = false;
  bool sincronizando = false;

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();

    
    try {
      await _repository.sincronizarChamados();
      offline = false;
    } catch (e) {
      offline = true;
    }

    chamados = await _repository.listarChamadosPorProximidade();
    carregando = false;
    notifyListeners();
  }

  
  Future<void> atualizarLista() async {
    chamados = await _repository.listarChamadosPorProximidade();
    notifyListeners();
  }

  
  Future<String> sincronizarAtendimentos() async {
    sincronizando = true;
    notifyListeners();

    String mensagem;
    try {
      final enviados = await _atendimentoRepository.sincronizarPendentes();
      mensagem = enviados == 0
          ? 'Nenhum atendimento pendente'
          : '$enviados atendimento(s) enviado(s) com sucesso';
    } catch (e) {
      mensagem = 'Não foi possível enviar. Verifique a internet e tente de novo.';
    }

    sincronizando = false;
    notifyListeners();
    return mensagem;
  }
}