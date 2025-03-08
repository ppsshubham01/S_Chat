import 'package:path/path.dart';
import 'package:s_chat/model/notes_models/notes_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  final String _taskTableName = "tasks";
  final String _taskIdColumnName = "id";
  final String _taskContentColumnName = "content";
  final String _taskStatusColumnName = "status";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'master_db.db');
    final database = await openDatabase(
      version: 1,
      databasePath,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE $_taskTableName ( 
        $_taskIdColumnName INTEGER PRIMARY KEY,
        $_taskContentColumnName TEXT NOT NULL,
        $_taskStatusColumnName INTEGER NOT NULL,
        ) ''');
      },
    );
    return database;
  }

  void addTask(String content) async {
    final db = await database;
    await db.insert(_taskTableName, {
      _taskContentColumnName: content,
      _taskStatusColumnName: 0,
    });
  }

  Future<List<NotesModel>?> getNotesData() async {

    final db =await database;
    final data = await db.query(_taskTableName);
    return null;
  }
}
