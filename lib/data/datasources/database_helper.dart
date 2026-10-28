import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/atendimento_model.dart';
import '../models/chamado_model.dart';
import '../models/historico_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._interno();
  DatabaseHelper._interno();

  static Database? _banco;

  Future<Database> get banco async {
    _banco ??= await _abrirBanco();
    return _banco!;
  }

  Future<Database> _abrirBanco() async {
    final pasta = await getDatabasesPath();
    final caminho = join(pasta, 'rota.db');
    return await openDatabase(caminho, version: 1, onCreate: _criarTabelas);
  }

  Future<void> _criarTabelas(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE chamados (
        id INTEGER PRIMARY KEY,
        codigo_cliente TEXT,
        nome_cliente TEXT,
        categoria_informada TEXT,
        descricao_problema TEXT,
        endereco_cliente TEXT,
        bairro TEXT,
        cidade TEXT,
        latitude REAL,
        longitude REAL,
        criado_em TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE atendimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chamado_id INTEGER,
        categoria_tecnico TEXT,
        descricao_procedimento TEXT,
        data_resolucao TEXT,
        caminho_foto TEXT,
        foto_url TEXT,
        sincronizado INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> salvarChamado(ChamadoModel chamado) async {
    final db = await banco;
    await db.insert(
      'chamados',
      chamado.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<ChamadoModel>> listarChamadosAbertos() async {
    final db = await banco;
    final resultado = await db.query(
      'chamados',
      where: 'status = ?',
      whereArgs: ['aberto'],
    );
    return resultado.map((linha) => ChamadoModel.fromMap(linha)).toList();
  }

  Future<void> marcarChamadoComoAtendido(int chamadoId) async {
    final db = await banco;
    await db.update(
      'chamados',
      {'status': 'atendido'},
      where: 'id = ?',
      whereArgs: [chamadoId],
    );
  }

  Future<int> salvarAtendimento(AtendimentoModel atendimento) async {
    final db = await banco;
    return await db.insert('atendimentos', atendimento.toMap());
  }

  Future<List<AtendimentoModel>> listarAtendimentosPendentes() async {
    final db = await banco;
    final resultado = await db.query(
      'atendimentos',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return resultado.map((linha) => AtendimentoModel.fromMap(linha)).toList();
  }

  // Todos os atendimentos (para a tela de histórico)
  Future<List<AtendimentoModel>> listarTodosAtendimentos() async {
    final db = await banco;
    final resultado = await db.query('atendimentos', orderBy: 'id DESC');
    return resultado.map((linha) => AtendimentoModel.fromMap(linha)).toList();
  }

  Future<void> marcarAtendimentoSincronizado(
    int atendimentoId, {
    String? fotoUrl,
  }) async {
    final db = await banco;
    await db.update(
      'atendimentos',
      {'sincronizado': 1, 'foto_url': fotoUrl},
      where: 'id = ?',
      whereArgs: [atendimentoId],
    );
  }

  Future<List<HistoricoItemModel>> listarHistorico() async {
    final db = await banco;
    final resultado = await db.rawQuery('''
      SELECT a.*, c.codigo_cliente, c.nome_cliente
      FROM atendimentos a
      LEFT JOIN chamados c ON c.id = a.chamado_id
      ORDER BY a.id DESC
    ''');
    return resultado.map((linha) => HistoricoItemModel.fromMap(linha)).toList();
  }
}
