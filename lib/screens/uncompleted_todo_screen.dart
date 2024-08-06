import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/providers/todo_provider.dart';
import 'package:todo_riverpod/screens/home_screen.dart';

class UncompletedTodoScreen extends ConsumerWidget {
  const UncompletedTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsyncValue = ref.watch(todoListProvider);
    return todosAsyncValue.when(
          data: (todos) {
            if (todos.isEmpty) {
              return Center(
                child: Text(
                  'TODOがありません',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Dismissible(
                    key: Key(todo.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      ref.read(todoListProvider.notifier).removeTodo(todo.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${todo.title}を削除しました'),
                          action: SnackBarAction(
                            label: '元に戻す',
                            onPressed: () {
                              ref
                                  .read(todoListProvider.notifier)
                                  .addTodo(todo.title, todo.description);
                            },
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isChecked,
                        onChanged: (_) {
                          ref.read(todoListProvider.notifier).toggleTodo(todo);
                        },
                      ),
                      title: Text(todo.title),
                      subtitle: Text(todo.description),
                      trailing: IconButton(
                        icon: Image.asset('assets/icon_edit.png'),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return EditTodo(todo: todo);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
          error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
          loading: () => Center(child: CircularProgressIndicator()));
  }
}
