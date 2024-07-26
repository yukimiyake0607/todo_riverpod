import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_riverpod/models/todo_model.dart';
import 'package:todo_riverpod/services/hive_todo_service.dart';
import 'package:uuid/uuid.dart';
part 'todo_provider.g.dart';

@riverpod
HiveTodoService hiveTodoService(HiveTodoServiceRef ref) {
  return HiveTodoService();
}

@riverpod
class TodoList extends _$TodoList {
  late HiveTodoService _todoService;

  @override
  FutureOr<List<TodoModel>> build() async {
    _todoService = ref.watch(hiveTodoServiceProvider);
    await _todoService.init();
    return _todoService.getTodos();
  }

  Future<void> addTodo(String title, String description) async {
    final newTodo = TodoModel(
        id: const Uuid().v4(), title: title, description: description);
    await _todoService.addTodo(newTodo);
    state = AsyncValue.data([...state.value!, newTodo]);
  }

  Future<void> removeTodo(String id) async {
    await _todoService.deleteTodo(id);
    state =
        AsyncValue.data(state.value!.where((todo) => todo.id != id).toList());
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _todoService.updateTodo(todo);
    state = AsyncValue.data(
        state.value!.map((t) => t.id == todo.id ? todo : t).toList());
  }

  Future<void> editTodo(
      String id, String newTitle, String newDescription) async {
    final currentState = state.value;
    if (currentState == null) return;

    final todoToEdit = currentState.firstWhere((todo) => todo.id == id);
    final updatedTodo = todoToEdit.copyWith(
      title: newTitle,
      description: newDescription,
    );

    await _todoService.updateTodo(updatedTodo);

    state = AsyncValue.data(currentState
        .map((todo) => todo.id == id ? updatedTodo : todo)
        .toList());
  }

  Future<void> toggleTodo(TodoModel todo) async {
    final updatedToggle = todo.copyWith(isChecked: !todo.isChecked);
    await updateTodo(updatedToggle);
  }
}
