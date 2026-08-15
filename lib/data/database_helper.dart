import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('controle_km.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        distancia REAL NOT NULL,
        litros REAL NOT NULL,
        resultado REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCalculo(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('calculos', row);
  }

  Future<List<Map<String, dynamic>>> fetchCalculos() async {
    final db = await instance.database;
    return await db.query('calculos', orderBy: 'id DESC');
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
