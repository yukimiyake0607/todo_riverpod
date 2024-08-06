import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/todo_model.dart';
import 'package:todo_riverpod/providers/todo_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsyncValue = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODOリスト',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: todosAsyncValue.when(
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
          loading: () => Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddTodo();
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddTodo extends ConsumerWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: SizedBox(
        height: 600.0,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              cursorColor: Colors.lightBlueAccent,
              decoration: const InputDecoration(
                labelText: 'TODO',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _descriptionController,
              cursorColor: Colors.lightBlueAccent,
              decoration: const InputDecoration(
                labelText: '内容',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  ref.read(todoListProvider.notifier).addTodo(
                      _titleController.text, _descriptionController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                '追加',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTodo extends ConsumerWidget {
  late final _newTitleController = TextEditingController(text: todo.title);
  late final _newDescriptionController =
      TextEditingController(text: todo.description);
  final TodoModel todo;

  EditTodo({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: SizedBox(
        height: 600.0,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: _newTitleController,
              decoration: const InputDecoration(
                labelText: 'TODO',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
            TextField(
              controller: _newDescriptionController,
              decoration: const InputDecoration(
                labelText: '内容',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_newTitleController.text.isNotEmpty) {
                  ref.read(todoListProvider.notifier).editTodo(todo.id,
                      _newTitleController.text, _newDescriptionController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('編集'),
            ),
          ],
        ),
      ),
    );
  }
}
