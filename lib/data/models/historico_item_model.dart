import 'atendimento_model.dart';

class HistoricoItemModel {
  final AtendimentoModel atendimento;
  final String codigoCliente;
  final String nomeCliente;

  HistoricoItemModel({
    required this.atendimento,
    required this.codigoCliente,
    required this.nomeCliente,
  });

  factory HistoricoItemModel.fromMap(Map<String, dynamic> map) {
    return HistoricoItemModel(
      atendimento: AtendimentoModel.fromMap(map),
      codigoCliente: map['codigo_cliente'] ?? '',
      nomeCliente: map['nome_cliente'] ?? '',
    );
  }
}
