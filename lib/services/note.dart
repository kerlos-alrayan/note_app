import 'package:to_do_list/helper/database_helper.dart';
import 'package:to_do_list/models/note_model.dart';

Future<int> addNote(Note note) async {
  final db = await DatabaseHelper.instance.database;
  return await db.insert('notes', note.toMap());
}

Future<List<Note>> getNotes() async {
  final db = await DatabaseHelper.instance.database;
  final result = await db.query('notes');
  return result.map((json) => Note.fromMap(json)).toList();
}

Future<int> updateNote(Note note) async {
  final db = await DatabaseHelper.instance.database;
  return await db.update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );
}

Future<int> deleteNote(int id) async {
  final db = await DatabaseHelper.instance.database;
  return await db.delete(
    'notes',
    where: 'id = ?',
    whereArgs: [id],
  );
}
