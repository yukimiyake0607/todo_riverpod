import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/app.dart';
import 'package:todo_riverpod/services/hive_todo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveTodoService = HiveTodoService();
  await hiveTodoService.init();
  runApp(ProviderScope(child: MainApp()));
}
