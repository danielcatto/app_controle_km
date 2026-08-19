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
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Criação das tabelas
  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE deslocamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        km REAL NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  // Inserir deslocamento
  Future<int> inserirDeslocamento(double km) async {
    final db = await database;

    return await db.insert(
      'deslocamentos',
      {
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
}
