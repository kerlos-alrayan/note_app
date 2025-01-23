import 'package:flutter/material.dart';
import 'package:to_do_list/models/note_model.dart';
import 'package:to_do_list/services/note.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  EditNotePage({required this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool isFavorite;
  late bool isArchived;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    isFavorite = widget.note.isFavorite == 1;
    isArchived = widget.note.isArchived == 1; // إضافة التحكم في الأرشيف
  }

  // دالة للتحقق من المدخلات
  bool _validateInputs() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            setState(() {
              widget.note.isFavorite = isFavorite ? 1 : 0;  // تحديث القيمة المفضلة
              widget.note.isArchived = isArchived ? 1 : 0; // تحديث القيمة الأرشيف
              updateNote(widget.note).then((_) {
                Navigator.pop(context); // العودة بعد التحديث
              });
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Edit Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_validateInputs()) {
                final updatedNote = Note(
                  id: widget.note.id, // استخدام المعرف القديم
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  isFavorite: isFavorite ? 1 : 0, // التأكد من تحديث قيمة isFavorite
                  isArchived: isArchived ? 1 : 0, // التأكد من تحديث قيمة isArchived
                );
                await updateNote(updatedNote); // استدعاء دالة تحديث الملاحظة
                Navigator.pop(context); // العودة إلى صفحة الملاحظات
              } else {
                // عرض رسالة تحذيرية في حال كانت الحقول فارغة
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert'),
                      content: const Text(
                        'Please make sure to fill both the title and content.',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // إغلاق الرسالة
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(
              Icons.check,
              color: Colors.teal,
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Add a new title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 15,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Add a new description for note',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Have a nice day😘',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
