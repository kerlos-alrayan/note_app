import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/screens/nit_task_screens/new_note.dart';
import 'package:to_do_list/presentation/screens/nit_task_screens/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> isFavorite = [];
  List<Map<String ,dynamic>> notes =[];

  // @override
  // void initState() {
  //   super.initState();
  //   isFavorite = List<bool>.filled(3, false);
  // }

  @override
  void initState(){
    super.initState();
    fetchNotes();
  }
  Future<void> fetchNotes() async{
    final data = await DBHelper.getDataFromDB();
    setState(() {
      notes = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.grey[300],
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  isFavorite.add(false);
                  return noteItem(notes[index]);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewNote()));
          },
          child: Icon(
            Icons.add,
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  Widget noteItem(Map<String, dynamic> note) {
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
            final newStatus =
            note['isFavorite'] == 1 ? 0 : 1;
            await DBHelper.updateFavoriteStatus(note['id'], newStatus);
            fetchNotes();
          },
        ),
      ),
    );
  }
}
