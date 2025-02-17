import 'package:app_planetas/models/planet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlanetController {
  static Database? _db;

  Future<Database> get db async {
  _db = await _initDB('planets.db');
  return _db!;
  }

  Future<Database> _initDB (String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path, 
      version: 1,
      onCreate: _createDB
      ); 
  }


  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        size REAL NOT NULL,
        distance REAL NOT NULL,
        nickname TEXT
      )
    ''');

  }

  Future<List<Planet>> readPlanets() async {
    final database = await db;
    final result = await database.query('planets');
    return result.map((map)=> Planet.fromMap(map)).toList();  
    

    
  }

  Future<void> addPlanet(Planet planet) async {
    final database = await db;
    await database.insert('planets', planet.toMap());
    
  }

  Future<int> editPlanet(Planet planet) async {
    final database = await db;
    return database.update('planets', planet.toMap(), where: 'id = ?', whereArgs: [planet.id]);
  }

  Future<void>deletePlanet(int id) async {
    final database = await db;
    await database.delete('planets', where: 'id = ?', whereArgs: [id]);
  }
} 