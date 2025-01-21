import 'package:flutter/material.dart';
import 'package:to_do_list/models/note_model.dart';
import 'package:to_do_list/presentation/screens/add_note.dart';
import 'package:to_do_list/presentation/screens/edit_note.dart';

import '../../services/note.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late Future<List<Note>> notesFuture;
  List<bool> isFavorite = [];

  @override
  void initState() {
    super.initState();
    notesFuture = getNotes(); // تحميل الملاحظات عند بدء الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.book,
          color: Colors.black,
          size: 30,
        ),
        title: const Text(
          'All Notes',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<Note>>(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes available'));
          } else {
            final notes = snapshot.data!;
            isFavorite = List<bool>.generate(
                notes.length, (index) => false); // تهيئة isFavorite

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                isFavorite.add(false);
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // الانتقال إلى صفحة تعديل الملاحظة
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNotePage(note: note),
                          ),
                        ).then((_) {
                          setState(() {
                            // بعد العودة من صفحة تعديل الملاحظة، قم بتحديث الملاحظات
                            notesFuture = getNotes();
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          height: 70,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Text(
                                  note.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              //SizedBox(width: 10,),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete Note'),
                                        content: const Text(
                                            'Are you sure you want to delete this note?🤔',
                                            style: TextStyle(fontSize: 16)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // إغلاق الحوار
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await deleteNote(note.id as int);
                                              setState(() {
                                                notesFuture = getNotes();
                                              });
                                              Navigator.of(context)
                                                  .pop(); // إغلاق الحوار بعد الحذف
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
            // الانتقال إلى صفحة إضافة الملاحظة
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNotePage()),
            ).then((_) {
              setState(() {
                // بعد العودة من صفحة إضافة الملاحظة، قم بتحديث الملاحظات
                notesFuture = getNotes();
              });
            });
          },
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.grey[100],
          ),
        ),
      ),
    );
  }
}
