import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/screens/add_note.dart';
import 'package:to_do_list/services/note.dart';
import 'package:to_do_list/models/note_model.dart';
import 'package:to_do_list/presentation/screens/edit_note.dart';
import 'package:to_do_list/presentation/screens/archived_note.dart';
import 'package:to_do_list/presentation/screens/favorite_note_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  NoteListPageState createState() => NoteListPageState();
}

class NoteListPageState extends State<NoteListPage> {
  late Future<List<Note>> notesFuture;
  List<bool> isFavorite = [];

  @override
  void initState() {
    super.initState();
    notesFuture = getNotes();
  }

  void _refreshNotes() {
    setState(() {
      notesFuture = getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArchivedNotesPage()),
              );
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.grey,
            ),
          ),
        ),
        title: const Text(
          'All Notes',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notes available'));
          } else {
            final notes = snapshot.data!;
            isFavorite = List<bool>.generate(
              notes.length,
                  (index) => notes[index].isFavorite == 1,
            );

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    key: ValueKey(note.id),
                    onDismissed: (direction) async{
                      await deleteNote(
                          note.id as int);
                      _refreshNotes();
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white,),
                    ),
                    child: Container(
                      //margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      //height: 70,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditNotePage(note: note),
                                      ),
                                    ).then((_) {
                                      _refreshNotes();
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
                                  // archive button
                                  IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        note.isArchived =
                                        note.isArchived == 1 ? 0 : 1;
                                      });

                                      await updateNote(note);

                                      _refreshNotes();
                                    },
                                    icon: Icon(
                                      note.isArchived == 1
                                          ? Icons.archive
                                          : Icons.archive_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // favorite button
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isFavorite[index] = !isFavorite[
                                        index];
                                        note.isFavorite = isFavorite[index]
                                            ? 1
                                            : 0;
                                        updateNote(
                                            note);
                                      });
                                    },
                                    icon: Icon(
                                      isFavorite[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite[index]
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(note.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          )
                        ],
                      ),
                    ),
                  ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNotePage()),
            ).then((_) {
              _refreshNotes();
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
