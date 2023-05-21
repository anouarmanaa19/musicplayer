import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<bool> isSongInFavorites(String songName) async {
    final db = await this.db;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM Favorites WHERE songName = ?',
      [songName],
    ));
    return count! > 0;
  }

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'favorites.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Favorites (id INTEGER PRIMARY KEY, songName TEXT, songPath TEXT)',
      );
    });
  }

  Future<int> insertFavorite(String songName, String songPath) async {
    final db = await this.db;
    final Map<String, dynamic> values = {
      'songName': songName,
      'songPath': songPath,
    };
    return await db.insert('Favorites', values);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await this.db;
    return await db.query('Favorites');
  }
}
