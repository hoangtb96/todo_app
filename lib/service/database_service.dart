import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/database/db.dart';

class DatabaseService {
  Future<int> insert(Map<String, Object?> data) async {
    final db = await DB.instance.db;
    final id = await db.insert(Constants.todosTable, data);
    return id;
  }

  Future<List<Map<String, Object?>>> getTodoListAll() async {
    final db = await DB.instance.db;
    final todosData = await db.query(Constants.todosTable,
        orderBy: '${Constants.colDate} DESC');
    return todosData;
  }

  Future<List<Map<String, Object?>>> getTodoListComplete() async {
    final db = await DB.instance.db;
    final todosData = await db.query(Constants.todosTable,
        where: '${Constants.colCompleted}= ?',
        whereArgs: [1],
        orderBy: '${Constants.colDate} DESC');
    return todosData;
  }

  Future<List<Map<String, Object?>>> getTodoListIncomplete() async {
    final db = await DB.instance.db;
    final todosData = await db.query(Constants.todosTable,
        where: '${Constants.colCompleted}= ?',
        whereArgs: [0],
        orderBy: '${Constants.colDate} DESC');
    return todosData;
  }

  Future<int> update(Map<String, Object?> data, int id) async {
    final db = await DB.instance.db;
    return await db.update(
      Constants.todosTable,
      data,
      where: '${Constants.colId}= ?',
      whereArgs: [id],
    );
  }

  // Future<int> delete(int id) async {
  //   final db = await DB.instance.db;
  //   ;
  //   return await db.delete(
  //     Constants.todosTable,
  //     where: '${Constants.colId} = ?',
  //     whereArgs: [id],
  //   );
  // }
}
