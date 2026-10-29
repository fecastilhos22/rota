import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  LoginViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  bool carregando = false;
  String? erro;

  Future<bool> entrar(String email, String senha) async {
    carregando = true;
    erro = null;
    notifyListeners(); 

    try {
      await _repository.fazerLogin(email, senha);
      carregando = false;
      notifyListeners();
      return true;
    } catch (e) {
      erro = e.toString().replaceFirst('Exception: ', '');
      carregando = false;
      notifyListeners();
      return false;
    }
  }
}