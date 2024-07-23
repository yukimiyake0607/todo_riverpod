import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_riverpod/models/todo_model.dart';
import 'package:uuid/uuid.dart';
part 'todo_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  List<TodoModel> build() {
    return [];
  }

  void addTodo(String title, String description) {
    final newTodo = TodoModel(id: const Uuid().v4(), title: title, description: description);
    state = [...state, newTodo];
  }

  void removeTodo() {}

  void toggleTodo() {}
}
