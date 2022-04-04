import 'package:flutter/material.dart';
import 'package:todo_app/module/note/model/todo_model.dart';

class AddTodoArguments {
  final VoidCallback updateTodos;
  final Todo? todo;

  AddTodoArguments({required this.updateTodos, this.todo});


}