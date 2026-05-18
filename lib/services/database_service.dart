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
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE bait_recipes(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              description TEXT,
              ingredients TEXT
            )
          ''');
          try {
            await db.execute('ALTER TABLE catches ADD COLUMN baitRecipeId INTEGER');
          } catch (e) {}
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
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
        baitRecipeId INTEGER,
        dateTime TEXT,
        photoPath TEXT,
        notes TEXT,
        spotId INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE bait_recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        ingredients TEXT
      )
    ''');
    await db.insert('spots', {
      'name': 'Ismeretlen helyszín',
      'notes': 'Alapértelmezett helyszín új fogásokhoz.',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllCatches() async {
    final db = await database;
    return await db.query('catches', orderBy: 'dateTime DESC');
  }

  Future<int> saveCatch(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('catches', data);
  }

  Future<int> deleteCatch(int id) async {
    final db = await database;
    return await db.delete('catches', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllSpots() async {
    final db = await database;
    return await db.query('spots');
  }

  Future<int> saveSpot(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('spots', data);
  }

  Future<int> deleteSpot(int id) async {
    final db = await database;
    // Don't delete the default spot (id 1)
    if (id == 1) return 0;
    return await db.delete('spots', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllBaitRecipes() async {
    final db = await database;
    return await db.query('bait_recipes');
  }

  Future<int> saveBaitRecipe(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('bait_recipes', data);
  }

  Future<int> deleteBaitRecipe(int id) async {
    final db = await database;
    return await db.delete('bait_recipes', where: 'id = ?', whereArgs: [id]);
  }
}
