import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/module/note/arguments/add_todo_arguments.dart';
import 'package:todo_app/module/note/bloc/todo_bloc.dart';
import 'package:todo_app/module/note/component/todo_header.dart';
import 'package:todo_app/module/note/component/todo_title.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/routes/routes_name.dart';

class ToDoListPage extends StatefulWidget {
  final ListLevel listLevel;
  const ToDoListPage({Key? key,required this.listLevel}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: ToDoBloc(todoRepo: Provider.of(context)),
        child: Consumer<ToDoBloc>(builder: (context, bloc, child) {
          bloc.event.add(ListToDoEvent(listLevel: widget.listLevel));
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteName.toDoCreatePage,
                      arguments: AddTodoArguments(updateTodos: () {
                bloc.event.add(ListToDoEvent(listLevel: widget.listLevel));
              })),
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
                child: StreamProvider<List<Todo>>.value(
              initialData: [],
              value: bloc.toDoStream,
              catchError: (context, error) {
                return [];
              },
              child: Consumer<List<Todo>>(builder: (context, todos, child) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  itemCount: 1 + todos.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) return TodoHeader(todos: todos,listLevel:widget.listLevel);
                    final todo = todos[index - 1];
                    return TodoTile(
                      updateTodos: () {
                        bloc.event.add(ListToDoEvent(listLevel: widget.listLevel));
                      },
                      todo: todo,
                      bloc: bloc,
                      listLevel: widget.listLevel,
                    );
                  },
                );
              }),
            )),
          );
        }),);
  }
}
