// Representa uma ordem de serviço (chamado)
class ChamadoModel {
  final int id;
  final String codigoCliente;
  final String nomeCliente;
  final String categoriaInformada;
  final String descricaoProblema;
  final String enderecoCliente;
  final String bairro;
  final String cidade;
  final double latitude;
  final double longitude;
  final String criadoEm;

 
  String _status;
  
  double? distanciaKm;

  ChamadoModel({
    required this.id,
    required this.codigoCliente,
    required this.nomeCliente,
    required this.categoriaInformada,
    required this.descricaoProblema,
    required this.enderecoCliente,
    required this.bairro,
    required this.cidade,
    required this.latitude,
    required this.longitude,
    required this.criadoEm,
    required String status,
  }) : _status = status;

  String get status => _status;


  void marcarComoAtendido() {
    _status = 'atendido';
  }


  String get enderecoCompleto => '$enderecoCliente - $bairro, $cidade';


  factory ChamadoModel.fromJson(Map<String, dynamic> json) {
    return ChamadoModel(
      id: json['id'],
      codigoCliente: json['codigo_cliente'],
      nomeCliente: json['nome_cliente'],
      categoriaInformada: json['categoria_informada'],
      descricaoProblema: json['descricao_problema'],
      enderecoCliente: json['endereco_cliente'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      criadoEm: json['criado_em'],
      status: json['status'] == 'ativo' ? 'aberto' : 'atendido',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo_cliente': codigoCliente,
      'nome_cliente': nomeCliente,
      'categoria_informada': categoriaInformada,
      'descricao_problema': descricaoProblema,
      'endereco_cliente': enderecoCliente,
      'bairro': bairro,
      'cidade': cidade,
      'latitude': latitude,
      'longitude': longitude,
      'criado_em': criadoEm,
      'status': _status,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo_cliente': codigoCliente,
      'nome_cliente': nomeCliente,
      'categoria_informada': categoriaInformada,
      'descricao_problema': descricaoProblema,
      'endereco_cliente': enderecoCliente,
      'bairro': bairro,
      'cidade': cidade,
      'latitude': latitude,
      'longitude': longitude,
      'criado_em': criadoEm,
      'status': _status,
    };
  }

  factory ChamadoModel.fromMap(Map<String, dynamic> map) {
    return ChamadoModel(
      id: map['id'],
      codigoCliente: map['codigo_cliente'],
      nomeCliente: map['nome_cliente'],
      categoriaInformada: map['categoria_informada'],
      descricaoProblema: map['descricao_problema'],
      enderecoCliente: map['endereco_cliente'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      criadoEm: map['criado_em'],
      status: map['status'],
    );
  }

  @override
  String toString() {
    return 'Chamado $id - $nomeCliente ($_status)';
  }
}