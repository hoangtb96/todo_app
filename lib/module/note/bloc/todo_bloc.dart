import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/common/base_bloc.dart';
import 'package:todo_app/common/base_event.dart';
import 'package:todo_app/common/error_msg_event.dart';
import 'package:todo_app/module/note/event/add_todo_event.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/event/todo_success_event.dart';
import 'package:todo_app/module/note/event/update_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/module/note/repo/todo_repo.dart';

class ToDoBloc extends BaseBloc with ChangeNotifier {
  late TodoRepo _todoRepo;
  final _toDoListSubject = BehaviorSubject<List<Todo>>();

  ToDoBloc({required TodoRepo todoRepo}) {
    _todoRepo = todoRepo;
  }

  // init list object for unit testing
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  int _todoID = -1;
  int get todoID => _todoID;

  // list todo steam
  Stream<List<Todo>> get toDoStream => _toDoListSubject.stream;

  @override
  Future<void> dispatchEvent(BaseEvent event) async {
    switch (event.runtimeType) {
      case ListToDoEvent:
        await _handleListTodo(event);
        break;
      case AddTodoEvent:
        await _handleAddTodo(event);
        break;
      case UpdateTodoEvent:
        await _handleUpdateTodo(event);
        break;

      default:
    }
  }

  Future<void> _handleListTodo(event) async {
    ListToDoEvent e = event as ListToDoEvent;

    await _todoRepo
        .getTodoLists(e)
        .then((value) => {_toDoListSubject.add(value), _todos = value})
        .catchError((error) => {
              processEventSink.add(ErrorMsgEvent(error)),
              _todos = [],
            });
  }

  Future<void> _handleAddTodo(event) async {
    AddTodoEvent e = event as AddTodoEvent;
    await _todoRepo
        .insert(e.todo)
        .then(
          (value) => {
            processEventSink.add(
              TodoSuccessEvent(todoID: value),
            ),
            _todoID = value,
          },
        )
        .catchError((error) => {
              processEventSink.add(ErrorMsgEvent(error)),
            });
  }

  Future<void> _handleUpdateTodo(event) async {
    UpdateTodoEvent e = event as UpdateTodoEvent;
    await _todoRepo
        .update(e.todo)
        .then(
          (value) => {
            processEventSink.add(
              TodoSuccessEvent(todoID: value),
            ),
            _todoID = value,
          },
        )
        .catchError((error) => {
              processEventSink.add(ErrorMsgEvent(error)),
            });
  }

  @override
  void disposeBloc() {
    _toDoListSubject.close();
    super.disposeBloc();
  }
}
