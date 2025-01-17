import 'package:flutter/material.dart';

class NewNote extends StatelessWidget {
  const NewNote({super.key});

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
          'Add Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.save,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),
            SizedBox(height: 20,),
            TextFormField(
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
          ],
        ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewNote()));
          },
          child: Icon(
            Icons.edit,
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
