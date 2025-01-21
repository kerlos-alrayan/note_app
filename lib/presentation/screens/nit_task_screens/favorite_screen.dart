import 'package:flutter/material.dart';
import 'package:to_do_list/presentation/screens/nit_task_screens/db_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> favoriteNotes = [];
  @override
  void initState(){
    super.initState();
    fatchFavoriteNotes();
  }
  Future<void> fatchFavoriteNotes() async{
    final data = await DBHelper.getFavoriteNotes();
    setState(() {
      favoriteNotes =data ?? [];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: favoriteNotes.isNotEmpty ?
      const Center(
       child: Text('No favorite notes available'), 
      ) 
          : ListView.builder(
          itemCount: favoriteNotes.length,
          itemBuilder: (context, index){
            final note = favoriteNotes[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  note['title'],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(note['content']),
              ),
            );
          })
    );
  }
}
