import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'habit_track.db';
  static const _dbVersion = 1;
  static const tableHabits = 'habis';

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableHabits (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL, 
      color_hex TEXT NOT NULL, 
      streak_count INTEGER NOT NULL DEFAULT 0, 
      last_checked_date TEXT
      )
      ''');
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return db.query(tableHabits);
  }

  Future<int> insert(Map<String, dynamic> habit) async {
    final db = await database;
    return db.insert(tableHabits, habit);
  }

  Future<int> update(Map<String, dynamic> habit) async {
    final db = await database;
    return db.update(
      tableHabits,
      habit,
      where: 'id= ?',
      whereArgs: [habit['id']],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(tableHabits, where: 'id = ?', whereArgs: [id]);
  }
}
