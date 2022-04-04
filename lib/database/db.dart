import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/constants/constants.dart';

class DB {
  static const DB instance = DB._();

  const DB._();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getDatabasesPath();
    final path = dir + '/todo_list.db';
    final todoListDb = await openDatabase(
      path,
      version: 5,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE ${Constants.todosTable} (
            ${Constants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Constants.colName} TEXT,
            ${Constants.colDate} TEXT,
            ${Constants.colPriorityLevel} TEXT,
            ${Constants.colCompleted} INTEGER
          )
        ''');
      },
    );
    return todoListDb;
  }
}
