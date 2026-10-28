import 'package:flutter/material.dart';
import '../data/models/chamado_model.dart';
import '../data/repositories/chamado_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ChamadoRepository _repository;

  HomeViewModel({ChamadoRepository? repository})
      : _repository = repository ?? ChamadoRepository();

  List<ChamadoModel> chamados = [];
  bool carregando = false;
  bool offline = false;

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
}