import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_riverpod/app.dart';

void main() async {
  await Hive.initFlutter();
  runApp(ProviderScope(child: MainApp()));
}
