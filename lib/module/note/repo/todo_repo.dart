import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/service/database_service.dart';

class TodoRepo {
  final DatabaseService _dbService;

  TodoRepo({required DatabaseService dbService}) : _dbService = dbService;

  Future<int> insert(Todo todo) async {
    var c = Completer<int>();
    try {
      final id = await _dbService.insert(todo.toMap());
      // final todoWithId = todo.copyWith(id: id);
      c.complete(id);
    } on DatabaseException catch (e) {
      c.completeError('Lỗi : ${e.toString()}');
    }
    return c.future;
  }

  Future<List<Todo>> getTodoLists(ListToDoEvent event) async {
    var c = Completer<List<Todo>>();
    List<Map<String, Object?>> todosData = [];
    try {
      switch (event.listLevel) {
        case ListLevel.all:
          todosData = await _dbService.getTodoListAll();

          break;
        case ListLevel.complete:
          todosData = await _dbService.getTodoListComplete();

          break;
        case ListLevel.incomplete:
          todosData = await _dbService.getTodoListIncomplete();

          break;
        default:
      }

      List<Todo> listData = todosData.map((e) => Todo.fromMap(e)).toList();
      if (listData.isEmpty) {
        c.complete([]);
      } else {
        c.complete(listData);
      }
    } on DatabaseException catch (e) {
      c.completeError('Lỗi : ${e.toString()}');
    }
    return c.future;
  }

  Future<int> update(Todo todo) async {
    var c = Completer<int>();
    try {
      final id = await _dbService.update(todo.toMap(), todo.id!);
      // final todoWithId = todo.copyWith(id: id);
      c.complete(id);
    } on DatabaseException catch (e) {
      c.completeError('Lỗi : ${e.toString()}');
    }
    return c.future;
  }
}
