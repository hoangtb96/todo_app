import 'package:flutter/material.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';

class TodoHeader extends StatelessWidget {
  final List<Todo> todos;
  final ListLevel listLevel;

  const TodoHeader({required this.todos, required this.listLevel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Todos',
            style: TextStyle(
              fontSize: Constants.sizeTextTitleScreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          _buildHeaderCountText(listLevel, todos),
        ],
      ),
    );
  }

  Widget _buildHeaderCountText(ListLevel listLevel, List<Todo> todos) {
    final completedTodosCount = todos.where((e) => e.completed).length;
    switch (listLevel) {
      case ListLevel.all:
        return Text(
          '$completedTodosCount of ${todos.length} completed',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: Constants.sizeTextTitlePopup,
            fontWeight: FontWeight.w600,
          ),
        );

      case ListLevel.complete:
        return Text(
          '$completedTodosCount completed',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: Constants.sizeTextTitlePopup,
            fontWeight: FontWeight.w600,
          ),
        );
      case ListLevel.incomplete:
        return Text(
          '${todos.length - completedTodosCount} incompleted',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: Constants.sizeTextTitlePopup,
            fontWeight: FontWeight.w600,
          ),
        );

      default:
        return Text(
          '$completedTodosCount of ${todos.length} completed',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: Constants.sizeTextTitlePopup,
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }
}
