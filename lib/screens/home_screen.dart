import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/todo_model.dart';
import 'package:todo_riverpod/providers/todo_provider.dart';
import 'package:todo_riverpod/screens/completed_todo_screen.dart';
import 'package:todo_riverpod/screens/uncompleted_todo_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoAppState();
}

class _TodoAppState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '未完了'),
            Tab(text: '完了'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UncompletedTodoScreen(),
          CompletedTodoScreen(),
        ],
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

  AddTodo({super.key});

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

EditTodo({super.key, required this.todo});

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
