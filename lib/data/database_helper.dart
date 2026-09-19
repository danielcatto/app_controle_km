import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Retorna o banco
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();

    final path = join(
      databasesPath,
      'controle_km.db',
    );

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Criação das tabelas
  // Criação das tabelas
  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // Tabela de deslocamentos
    await db.execute('''
      CREATE TABLE deslocamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        km REAL NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await _criarTabelaConfiguracoes(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _criarTabelaConfiguracoes(db);
    }
  }

  Future<void> _criarTabelaConfiguracoes(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS configuracoes (
        id INTEGER PRIMARY KEY,
        tipo_combustivel TEXT
      )
    ''');

    await db.insert(
      'configuracoes',
      {
        'id': 1,
        'tipo_combustivel': 'Etanol',
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Inserir deslocamento
  Future<int> inserirDeslocamento(String descricao, double km) async {
    final db = await database;

    return await db.insert(
      'deslocamentos',
      {
        'descricao': descricao,
        'km': km,
        'data': DateTime.now().toIso8601String(),
      },
    );
  }

  // Listar deslocamentos
  Future<List<Map<String, dynamic>>> listarDeslocamentos() async {
    final db = await database;

    return await db.query(
      'deslocamentos',
      orderBy: 'id DESC',
    );
  }

  // Somar todos os quilômetros
  Future<double> totalKm() async {
    final db = await database;

    final resultado = await db.rawQuery('''
      SELECT SUM(km) AS total
      FROM deslocamentos
    ''');

    final total = resultado.first['total'];

    if (total == null) {
      return 0.0;
    }

    return (total as num).toDouble();
  }

  // Excluir um deslocamento
  Future<int> excluirDeslocamento(int id) async {
    final db = await database;

    return await db.delete(
      'deslocamentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Excluir TODOS os deslocamentos
  Future<void> deletarTodosDeslocamentos() async {
    final db = await database;

    await db.delete('deslocamentos');
  }

  Future<void> salvarCombustivelNoBanco(String tipo) async {
    final db = await database; // Sua função de conexão SQLite
    await db.insert(
      'configuracoes',
      {'id': 1, 'tipo_combustivel': tipo},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
