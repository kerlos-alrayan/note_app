import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list/models/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // From my Package sqfLite
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE notes (
      id $idType,
      title $textType,
      content $textType
    )''');
  }

  Future<List<Note>> getNotes() async {
    final db = await database; // استدعاء قاعدة البيانات
    final result = await db.query('notes'); // جلب جميع الملاحظات من الجدول
    return result
        .map((json) => Note.fromMap(json))
        .toList(); // تحويل كل سجل إلى كائن Note
  }
}
