// Representa o técnico que faz login
class UsuarioModel {
  final int id;
  final String nome;
  final String email;

  UsuarioModel({required this.id, required this.nome, required this.email});

 
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'email': email};
  }


  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'email': email};
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
    );
  }
}
