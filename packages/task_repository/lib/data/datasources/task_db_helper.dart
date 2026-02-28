import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDbHelper {
  static const _dbName = 'tasks.db';
  static const _dbVersion = 1;
  static const _table = 'tasks';

  static final TaskDbHelper instance = TaskDbHelper._internal();
  TaskDbHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    print('DB PATH: $dbPath'); // <-- check your console output
    
    final path = join(dbPath, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE $_table (
      id TEXT PRIMARY KEY NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      duration REAL NOT NULL,
      duDateMilliseconds INTEGER NOT NULL,
      categoryModel TEXT NOT NULL,
      priority TEXT NOT NULL,
      complexity TEXT NOT NULL,
      project TEXT,
      tags TEXT NOT NULL,
      status TEXT NOT NULL,
      completionRate REAL NOT NULL,
      isDoneInt INTEGER NOT NULL CHECK (isDoneInt IN (0, 1)),
      orderIndex INTEGER NOT NULL DEFAULT 0
    )
  ''');
}

}
