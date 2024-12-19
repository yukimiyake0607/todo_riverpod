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
    final allTodos = _todoService.getTodos();
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
      uncompletedTodos: [..._todoState.uncompletedTodos, newTodo],
      completedTodos: _todoState.completedTodos,
    );
    state = AsyncValue.data(_todoState.allTodos);
  }

  Future<void> removeTodo(String id) async {
    await _todoService.deleteTodo(id);
    _todoState = TodoState(
      uncompletedTodos:
          _todoState.uncompletedTodos.where((todo) => todo.id != id).toList(),
      completedTodos:
          _todoState.completedTodos.where((todo) => todo.id != id).toList(),
    );
    state = AsyncValue.data(_todoState.allTodos);
  }

  
  Future<void> updateTodo(TodoModel todo) async {
    await _todoService.updateTodo(todo);
    _todoState = TodoState(
      uncompletedTodos: _todoState.uncompletedTodos
          .map((t) => t.id == todo.id ? todo : t)
          .toList(),
      completedTodos: _todoState.completedTodos
          .map((t) => t.id == todo.id ? todo : t)
          .toList(),
    );
    state = AsyncValue.data(_todoState.allTodos);
  }

  Future<void> editTodo(
      String id, String newTitle, String newDescription) async {
    final todoToEdit = _todoState.allTodos.firstWhere((todo) => todo.id == id);
    final updatedTodo = todoToEdit.copyWith(
      title: newTitle,
      description: newDescription,
    );

    await _todoService.updateTodo(updatedTodo);

    _todoState = TodoState(
      uncompletedTodos: _todoState.uncompletedTodos
          .map((todo) => todo.id == id ? updatedTodo : todo)
          .toList(),
      completedTodos: _todoState.completedTodos
          .map((todo) => todo.id == id ? updatedTodo : todo)
          .toList(),
    );
    state = AsyncValue.data(_todoState.allTodos);
  }

  Future<void> toggleTodo(TodoModel todo) async {
    final updatedTodo = todo.copyWith(isChecked: !todo.isChecked);
    await _todoService.updateTodo(updatedTodo);

    if (updatedTodo.isChecked) {
      _todoState = TodoState(
        uncompletedTodos:
            _todoState.uncompletedTodos.where((t) => t.id != todo.id).toList(),
        completedTodos: [..._todoState.completedTodos, updatedTodo],
      );
    } else {
      _todoState = TodoState(
        uncompletedTodos: [..._todoState.uncompletedTodos, updatedTodo],
        completedTodos:
            _todoState.completedTodos.where((t) => t.id != todo.id).toList(),
      );
    }
    state = AsyncValue.data(_todoState.allTodos);
  }

  List<TodoModel> get uncompletedTodos => _todoState.uncompletedTodos;
  List<TodoModel> get completedTodos => _todoState.completedTodos;
}
