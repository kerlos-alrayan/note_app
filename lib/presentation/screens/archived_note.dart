import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/screens/edit_note.dart';
import 'package:to_do_list/presentation/screens/test_db.dart';
import 'package:to_do_list/services/note.dart';
import '../../models/note_model.dart';

class ArchivedNotesPage extends StatefulWidget {
  const ArchivedNotesPage({super.key});

  @override
  State<ArchivedNotesPage> createState() => _ArchivedNotesPageState();
}

class _ArchivedNotesPageState extends State<ArchivedNotesPage> {
  late Future<List<Note>> notesFuture;
  List<bool> isFavorite = [];
  void _refreshNotes() {
    setState(() {
      notesFuture = getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteListPage()));
        },),
        title: const Text(
          "Archived Notes",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Note>>(
        future: getArchivedNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No archived notes available.'));
          } else {
            final notes = snapshot.data!;
            isFavorite = notes.map((note) => note.isFavorite == 1).toList();
            return Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditNotePage(note: note),
                                ),
                              ).then((_) {
                                setState(() {
                                  notesFuture = getArchivedNotes();
                                });
                              });
                            },
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
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.archive,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                note.isArchived = 0;
                                updateNote(note).then((_) {
                                  _refreshNotes();
                                });
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isFavorite[index] = !isFavorite[index];
                                  note.isFavorite = isFavorite[index] ? 1 : 0;
                                  updateNote(note);
                                });
                              },
                              icon: Icon(
                                isFavorite[index] ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite[index] ? Colors.red : Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Note'),
                                      content: const Text(
                                        'Are you sure you want to delete this note?🤔',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await deleteNote(note.id as int);
                                            _refreshNotes();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

}


