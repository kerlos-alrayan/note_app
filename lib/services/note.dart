import 'package:to_do_list/helper/database_helper.dart';
import 'package:to_do_list/models/note_model.dart';

// إضافة ملاحظة
Future<int> addNote(Note note) async {
  final db = await DatabaseHelper.instance.database; // استدعاء instance هنا
  return await db.insert('notes', note.toMap());
}

// الحصول على كل الملاحظات
Future<List<Note>> getNotes() async {
  final db = await DatabaseHelper.instance.database; // استدعاء instance هنا
  final result = await db.query('notes');
  return result.map((json) => Note.fromMap(json)).toList();
}

// تحديث ملاحظة
Future<int> updateNote(Note note) async {
  final db = await DatabaseHelper.instance.database; // استدعاء instance هنا
  return await db.update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );
}

// حذف ملاحظة
Future<int> deleteNote(int id) async {
  final db = await DatabaseHelper.instance.database; // استدعاء instance هنا
  return await db.delete(
    'notes',
    where: 'id = ?',
    whereArgs: [id],
  );
}
