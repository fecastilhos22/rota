import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageDatasource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _chaveToken = 'token';

  Future<void> salvarToken(String token) async {
    await _storage.write(key: _chaveToken, value: token);
  }

  Future<String?> lerToken() async {
    return await _storage.read(key: _chaveToken);
  }

  Future<void> apagarToken() async {
    await _storage.delete(key: _chaveToken);
  }
}