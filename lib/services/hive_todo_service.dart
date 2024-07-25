import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_riverpod/models/todo_model.dart';

class HiveTodoService {
  final String _boxName = 'todos';

  Future<void> init() async {
    Hive.registerAdapter(TodoModelAdapter());
    await Hive.openBox<TodoModel>(_boxName);
  }

  Future<void> addTodo(TodoModel todo) async {
    final box = Hive.box<TodoModel>(_boxName);
    await box.put(todo.id, todo);
  }

  Future<void> updateTodo(TodoModel todo) async {
    final box = Hive.box<TodoModel>(_boxName);
    await box.put(todo.id, todo);
  }

  Future<void> deleteTodo(String id) async {
    final box = Hive.box<TodoModel>(_boxName);
    box.delete(id);
  }

  List<TodoModel> getTodos() {
    final box = Hive.box<TodoModel>(_boxName);
    return box.values.toList();
  }

  Stream<List<TodoModel>> watchTodos() {
    final box = Hive.box<TodoModel>(_boxName);
    return box.watch().map((_) => box.values.toList());
  }
}
