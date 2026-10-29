
class AtendimentoModel {
  final int? id; 
  final int chamadoId;
  final String categoriaTecnico;
  final String descricaoProcedimento;
  final String dataResolucao;
  final String? caminhoFoto; 
  final String? fotoUrl; 
  final int sincronizado;

  AtendimentoModel({
    this.id,
    required this.chamadoId,
    required this.categoriaTecnico,
    required this.descricaoProcedimento,
    required this.dataResolucao,
    this.caminhoFoto,
    this.fotoUrl,
    this.sincronizado = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'chamado_id': chamadoId,
      'categoria_tecnico': categoriaTecnico,
      'descricao_procedimento': descricaoProcedimento,
      'data_resolucao': dataResolucao,
    };
  }


  factory AtendimentoModel.fromJson(Map<String, dynamic> json, int chamadoId) {
    return AtendimentoModel(
      id: json['id'],
      chamadoId: chamadoId,
      categoriaTecnico: json['categoria_tecnico'],
      descricaoProcedimento: json['descricao_procedimento'],
      dataResolucao: json['data_resolucao'],
      fotoUrl: json['foto_url'],
      sincronizado: 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chamado_id': chamadoId,
      'categoria_tecnico': categoriaTecnico,
      'descricao_procedimento': descricaoProcedimento,
      'data_resolucao': dataResolucao,
      'caminho_foto': caminhoFoto,
      'foto_url': fotoUrl,
      'sincronizado': sincronizado,
    };
  }

  factory AtendimentoModel.fromMap(Map<String, dynamic> map) {
    return AtendimentoModel(
      id: map['id'],
      chamadoId: map['chamado_id'],
      categoriaTecnico: map['categoria_tecnico'],
      descricaoProcedimento: map['descricao_procedimento'],
      dataResolucao: map['data_resolucao'],
      caminhoFoto: map['caminho_foto'],
      fotoUrl: map['foto_url'],
      sincronizado: map['sincronizado'],
    );
  }
}