import 'package:flutter/material.dart';
import 'package:todo_riverpod/screens/home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
}
