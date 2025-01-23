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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const isFavorite = 'INTEGER DEFAULT 0';
    const isArchived = 'INTEGER DEFAULT 0'; // إضافة عمود الأرشفة

    await db.execute('''CREATE TABLE notes (
      id $idType,
      title $textType,
      content $textType,
      isFavorite $isFavorite,
      isArchived $isArchived  -- إضافة العمود هنا
    )''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN isFavorite INTEGER DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE notes ADD COLUMN isArchived INTEGER DEFAULT 0');
    }
  }

  Future<List<Note>> getNotes({int? isFavorite, int? isArchived}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (isFavorite != null) {
      whereClause += 'isFavorite = ?';
      whereArgs.add(isFavorite);
    }

    if (isArchived != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'isArchived = ?';
      whereArgs.add(isArchived);
    }

    final result = await db.query('notes', where: whereClause.isNotEmpty ? whereClause : null, whereArgs: whereArgs.isNotEmpty ? whereArgs : null);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    final db = await database;
    try {
      await db.update(
        'notes',
        {'isFavorite': isFavorite},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update favorite status error: $e');
    }
  }

  Future<List<Note>> getFavoriteNotes() async {
    final db = await database;
    final result = await db.query('notes', where: 'isFavorite = ?', whereArgs: [1]);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<List<Note>> getArchivedNotes() async {
    final db = await database;
    final result = await db.query('notes', where: 'isArchived = ?', whereArgs: [1]);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<void> updateArchivedStatus(int id, int isArchived) async {
    final db = await database;
    try {
      await db.update(
        'notes',
        {'isArchived': isArchived},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update archived status error: $e');
    }
  }

  Future<int> addNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future close() async {
    final db = await _database;
    db?.close();
  }
}
