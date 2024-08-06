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

class TodoState {
  final List<TodoModel> uncompletedTodos;
  final List<TodoModel> completedTodos;

  TodoState({required this.uncompletedTodos, required this.completedTodos});

  List<TodoModel> get allTodos => [...uncompletedTodos, ...completedTodos];
}

@riverpod
class TodoList extends _$TodoList {
  late HiveTodoService _todoService;
  late TodoState _todoState;

  @override
  FutureOr<List<TodoModel>> build() async {
    _todoService = ref.watch(hiveTodoServiceProvider);
    await _todoService.init();
    final allTodos = await _todoService.getTodos();
    _todoState = TodoState(
      uncompletedTodos: allTodos.where((todo) => !todo.isChecked).toList(),
      completedTodos: allTodos.where((todo) => todo.isChecked).toList(),
    );
    return _todoState.allTodos;
  }

  Future<void> addTodo(String title, String description) async {
    final newTodo = TodoModel(
        id: const Uuid().v4(), title: title, description: description);
    await _todoService.addTodo(newTodo);
    _todoState = TodoState(
      uncompletedTodos: [..._todoState.uncompletedTodos],
      completedTodos: _todoState.completedTodos,
    );
    state = AsyncValue.data(_todoState.allTodos);
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
