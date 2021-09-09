import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabaseLocal {
  static Database? _database;

  static Future<Database> get database async {
    if (_database == null) {
      _database = await _initialiseDatabase();
    }

    return _database!;
  }

  static Future<Database> _initialiseDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "dog.db");

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
    );

    return database;
  }
}
