import 'package:flutter/material.dart';
import 'package:statefulwidget_todo_app/models/todos/todo.dart';

class TodosListPage extends StatefulWidget {
  const TodosListPage({Key? key}) : super(key: key);
  @override
  _TodosListPageState createState() => _TodosListPageState();
}

class _TodosListPageState extends State<TodosListPage> {
  final List<Todo> _todos = <Todo>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Todoアプリ'),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final todo = _todos[index];
            return Dismissible(
              key: ObjectKey(todo),
              child: Card(
                child: ListTile(
                  title: Text(todo.name),
                  onTap: () {
                    setState(() {
                      _todos[index] =
                          Todo(isCompleted: !todo.isCompleted, name: todo.name);
                    });
                  },
                  trailing: todo.isCompleted
                      ? const Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : null,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  _todos.removeAt(index);
                });
              },
            );
          },
          itemCount: _todos.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoAddDialog(
              context: context,
              onAdd: (name) {
                setState(() {
                  _todos.insert(0, Todo(name: name));
                });
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showTodoAddDialog({
    required BuildContext context,
    required Function(String name) onAdd,
  }) {
    TextEditingController textEditingController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('new Todo'),
            content: TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: 'Enter todo name'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  String todoName = textEditingController.text;
                  onAdd(todoName);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              )
            ],
          );
        });
  }
}
