import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:build_runner/build_runner.dart';
import 'package:todo_riverpod/models/todo_model.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  List<TodoModel> build() {
    return [];
  }

  void addTodo(String id, String title, String description) {
    final newTodo = TodoModel(id: id, title: title, description: description);
    state = [...state, newTodo];
  }

  void removeTodo() {}

  void toggleTodo() {}
}
