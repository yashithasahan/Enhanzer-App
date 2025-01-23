import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database _database;

  Future<void> initDatabase() async {
    final databasePath = await getDatabasesPath();
    _database = await openDatabase(
      join(databasePath, 'app.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchUser() async {
    return await _database.query('user');
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final database = await openDatabase(
      'app.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user (id TEXT PRIMARY KEY, name TEXT, email TEXT)',
        );
      },
    );

    await database.insert(
      'user',
      {
        'id': userData['User_Code'],
        'name': userData['User_Display_Name'],
        'email': userData['Email'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    var logger = Logger();
    logger.w("User data saved successfully");

    await database.close();
  }

  Future<void> clearUserData() async {
    await _database.delete('user');
    Logger().i("User data cleared successfully");
  }
}
