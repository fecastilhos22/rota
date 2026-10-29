import '../datasources/database_helper.dart';
import '../models/historico_item_model.dart';

class HistoricoRepository {
  final DatabaseHelper _banco;

  HistoricoRepository({DatabaseHelper? banco})
      : _banco = banco ?? DatabaseHelper.instance;

  Future<List<HistoricoItemModel>> listarHistorico() {
    return _banco.listarHistorico();
  }
}