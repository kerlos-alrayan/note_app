import 'package:to_do_list/helper/database_helper.dart';
import 'package:to_do_list/models/note_model.dart';

Future<int> addNote(Note note) async {
  final db = await DatabaseHelper.instance.database;
  try {
    int result = await db.insert('notes', note.toMap());
    return result;
  } catch (e) {
    print('Error inserting note: $e');
    return -1;
  }
}

Future<List<Note>> getNotes({int limit = 20, int offset = 0}) async {
  final db = await DatabaseHelper.instance.database;
  try {
    final result = await db.query(
      'notes',
      where: 'isArchived = ?',
      whereArgs: [0],
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );
    return result.map((json) => Note.fromMap(json)).toList();
  } catch (e) {
    print('Error retrieving notes: $e');
    return [];
  }
}

Future<int> updateNote(Note note) async {
  final db = await DatabaseHelper.instance.database;
  try {
    int updatedCount = await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    if (updatedCount == 0) {
      print('No note updated');
    }
    return updatedCount;
  } catch (e) {
    print('Error updating note: $e');
    return 0;
  }
}

Future<int> deleteNote(int id) async {
  final db = await DatabaseHelper.instance.database;
  try {
    int deleteCount = await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return deleteCount;
  } catch (e) {
    print('Error deleting note: $e');
    return 0;
  }
}

Future<int> updateFavoriteStatus(int id, int isFavorite) async {
  final db = await DatabaseHelper.instance.database;
  try {
    int result = await db.update(
      'notes',
      {'isFavorite': isFavorite},
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  } catch (e) {
    print('Error updating favorite status: $e');
    return 0;
  }
}

Future<List<Note>> getFavoriteNotes() async {
  final db = await DatabaseHelper.instance.database;
  try {
    final result = await db.query(
      'notes',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return result.map((json) => Note.fromMap(json)).toList();
  } catch (e) {
    print('Error retrieving favorite notes: $e');
    return [];
  }
}

Future<List<Note>> getArchivedNotes() async {
  final db = await DatabaseHelper.instance.database;
  try {
    final result = await db.query(
      'notes',
      where: 'isArchived = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  } catch (e) {
    print('Error retrieving archived notes: $e');
    return [];
  }
}
