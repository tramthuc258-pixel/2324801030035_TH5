import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/note_storage.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.storage});

  final NoteStorage? storage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghi chú cá nhân',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(storage: storage ?? NoteStorage()),
    );
  }
}
