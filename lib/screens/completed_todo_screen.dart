import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/providers/todo_provider.dart';

class CompletedTodoScreen extends ConsumerWidget {
  const CompletedTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsyncValue = ref.watch(todoListProvider);
    return todosAsyncValue.when(
      data: (todos) {
        if (todos.isEmpty) {
          return Center(
            child: Text(
              '完了したTODOはありません',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: IconButton(
                  onPressed: () {
                    ref.watch(todoListProvider.notifier).toggleTodo(todo);
                  },
                  icon: const Icon(Icons.undo),
                ),
              );
            },
          );
        }
      },
      error: (error, stack) => Text('Error: $error'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
