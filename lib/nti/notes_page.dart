import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'favorite_note_page.dart';
import 'new_note.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => NotesState();
}

class NotesState extends State<Notes> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      final data = await DBHelper.getDataFromDB();
      setState(() {
        notes = data ?? [];
      });
    } catch (e) {
      _showErrorSnackBar("Failed to fetch notes: $e");
    }
  }

  Future<void> _addNote(Map<String, String> newNote) async {
    try {
      await DBHelper.insertToDB(newNote["title"]!, newNote["note"]!);
      await _fetchNotes();
    } catch (e) {
      _showErrorSnackBar("Failed to add note: $e");
    }
  }

  Future<void> _updateFavoriteStatus(int id, int newStatus) async {
    try {
      await DBHelper.updateFavoriteStatus(id, newStatus);
      await _fetchNotes();
    } catch (e) {
      _showErrorSnackBar("Failed to update favorite status: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: notes.isEmpty ? _buildEmptyState() : _buildNotesList(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: const Icon(
        Icons.book,
        color: Colors.black,
        size: 30,
      ),
      title: const Text(
        "All Notes",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite, color: Colors.redAccent),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Favorites()),
            );
          },
        ),
      ],
    );
  }

  Center _buildEmptyState() {
    return const Center(
      child: Text(
        "No notes available.",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  ListView _buildNotesList() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildNoteItem(notes[index]);
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewNote(),
          ),
        );

        if (result != null && result is Map<String, String>) {
          await _addNote(result);
        }
      },
      backgroundColor: Colors.grey[200],
      child: const Icon(
        Icons.add,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  Card _buildNoteItem(Map<String, dynamic> note) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          note['Title'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(note['Note']),
        trailing: IconButton(
          icon: Icon(
            note['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
          ),
          onPressed: () async {
            final newStatus = note['isFavorite'] == 1 ? 0 : 1;
            await _updateFavoriteStatus(note['id'], newStatus);
          },
        ),
      ),
    );
  }
}
