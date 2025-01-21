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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          'Edit Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final updatedNote = Note(
                id: widget.note.id, // استخدم المعرف القديم
                title: _titleController.text,
                content: _contentController.text,
              );
              await updateNote(updatedNote); // استدعاء دالة تحديث الملاحظة
              Navigator.pop(context); // العودة إلى صفحة الملاحظات
            },
            icon: Icon(
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
              const Text('Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20,),
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
              SizedBox(height: 40,),
              const Text('Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20,),
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
              SizedBox(height: MediaQuery.of(context).size.height *0.1,),
              Text('Have a nice day😘',
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
