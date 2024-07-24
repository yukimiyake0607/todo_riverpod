import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_riverpod/models/todo_model.dart';
import 'package:todo_riverpod/providers/todo_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
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
      body: todos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/task_completed.png'),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    '現在タスクはありません',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isChecked,
                    onChanged: (_) {
                      ref.read(todoListProvider.notifier).toggleTodo(todo.id);
                    },
                  ),
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return EditTodo(todo: todo);
                            },
                          );
                        },
                        child: const Text('編集'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(todoListProvider.notifier)
                              .removeTodo(todo.id);
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
              },
            ),
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
              decoration: const InputDecoration(
                labelText: 'TODO',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
            TextField(
              controller: _descriptionController,
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
                if (_titleController.text.isNotEmpty) {
                  ref.read(todoListProvider.notifier).addTodo(
                      _titleController.text, _descriptionController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTodo extends ConsumerWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'TODO',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
            TextField(
              controller: _descriptionController,
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
                if (_titleController.text.isNotEmpty) {
                  ref.read(todoListProvider.notifier).editTodo(todo.id, _titleController.text, _descriptionController.text);
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
