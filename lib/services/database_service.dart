import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fishing_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE spots(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            latitude REAL,
            longitude REAL,
            notes TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE catches(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            species TEXT,
            weight REAL,
            length REAL,
            bait TEXT,
            dateTime TEXT,
            photoPath TEXT,
            notes TEXT,
            spotId INTEGER
          )
        ''');
        // Alapértelmezett helyszín
        await db.insert('spots', {
          'name': 'Ismeretlen helyszín',
          'notes': 'Alapértelmezett helyszín új fogásokhoz.',
          'createdAt': DateTime.now().toIso8601String(),
        });
      },
    );
  }

  // Fogások
  Future<List<Map<String, dynamic>>> getAllCatches() async {
    final db = await database;
    return await db.query('catches', orderBy: 'dateTime DESC');
  }

  Future<int> saveCatch(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('catches', data);
  }

  // Helyszínek
  Future<List<Map<String, dynamic>>> getAllSpots() async {
    final db = await database;
    return await db.query('spots');
  }

  Future<int> saveSpot(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('spots', data);
  }
}
