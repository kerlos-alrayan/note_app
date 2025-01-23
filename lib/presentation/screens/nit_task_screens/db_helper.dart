import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? db;
  static Future<void> createDB() async {
    if (db != null) return;
    try {
      String path = '${await getDatabasesPath()}/note.db';
      db = await openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          isFavorite INTEGER DEFAULT 0
          ) 
          ''');
      });
      await addFavoriteColumnIfNotExists();
    } catch (e) {
      print('Database creation error: $e');
    }
  }

  static Future<void> insertToDB(String title, String content) async {
    try {
      await db?.insert('note', {
        'title': title,
        'content': content,
      });
    } catch (e) {
      print('Insert error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getDataFromDB() async {
    try {
      return await db?.query('note');
    } catch (e) {
      print('Fetch error: $e');
      return null;
    }
  }

  static Future<void> addFavoriteColumnIfNotExists() async {
    try {
      await db?.execute(''
          'ALTER TABLE not ADD COLUMN isFavorite INTEGER DEFAULT 0');
    } catch (e) {
      print('Erroe adding isFavorite column: $e');
    }
  }

  static Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    try {
      await db?.update(
        'note',
        {'isFavorite': isFavorite},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update favorite status error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getFavoriteNotes() async {
    try {
      return await db?.query('note', where: 'isFavorite = ?', whereArgs: [1]);
    } catch (e) {
      print('Error $e');
      return null;
    }
  }
}
