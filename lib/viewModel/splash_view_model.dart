import '../data/repositories/auth_repository.dart';

class SplashViewModel {
  final AuthRepository _repository;

  SplashViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  Future<bool> temSessao() {
    return _repository.temSessao();
  }
}