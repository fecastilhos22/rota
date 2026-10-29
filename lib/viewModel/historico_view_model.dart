import 'package:flutter/material.dart';
import '../data/models/historico_item_model.dart';
import '../data/repositories/historico_repository.dart';

class HistoricoViewModel extends ChangeNotifier {
  final HistoricoRepository _repository;

  HistoricoViewModel({HistoricoRepository? repository})
    : _repository = repository ?? HistoricoRepository();

  List<HistoricoItemModel> _todos = [];
  List<HistoricoItemModel> itens = [];
  bool carregando = false;

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();

    _todos = await _repository.listarHistorico();
    itens = _todos;

    carregando = false;
    notifyListeners();
  }

  void filtrar(String texto) {
    final busca = texto.trim().toLowerCase();

    if (busca.isEmpty) {
      itens = _todos;
    } else {
      itens = _todos
          .where(
            (item) =>
                item.atendimento.chamadoId.toString().contains(busca) ||
                item.codigoCliente.toLowerCase().contains(busca),
          )
          .toList();
    }
    notifyListeners();
  }

  int get totalPendentes =>
      _todos.where((item) => item.atendimento.sincronizado == 0).length;

  bool get todosSincronizados =>
      _todos.every((item) => item.atendimento.sincronizado == 1);
}
