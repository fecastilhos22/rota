import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';


class LoginResposta {
  final String token;
  final UsuarioModel usuario;
  LoginResposta({required this.token, required this.usuario});
}


class AuthRemoteDatasource {
  static const String baseUrl = 'https://oquetemnomeucosmetico.com.br/api';

 
  static const String _chaveSecreta = r'ISP_TECH_SENAI_2026_xK9#mQ2$vL8!zP4';

  
  String gerarHmac(String senha) {
    final chave = utf8.encode(_chaveSecreta);
    final mensagem = utf8.encode(senha);
    final hmac = Hmac(sha256, chave);
    return hmac.convert(mensagem).toString();
  }

  Future<LoginResposta> login(String email, String senha) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha_hmac': gerarHmac(senha)}),
    );

    final corpo = jsonDecode(resposta.body);

    if (resposta.statusCode == 200 && corpo['sucesso'] == true) {
      return LoginResposta(
        token: corpo['dados']['token'],
        usuario: UsuarioModel.fromJson(corpo['dados']['usuario']),
      );
   }
    throw Exception(corpo['mensagem'] ?? 'Erro ao fazer login');
  }
}