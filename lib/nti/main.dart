// main.dart
import 'package:flutter/material.dart';
import 'package:to_do_list/nti/notes_page.dart';

import '../presentation/screens/nit_task_screens/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DBHelper.deleteDB();
  await DBHelper.createDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Notes(),
    );
  }
}


