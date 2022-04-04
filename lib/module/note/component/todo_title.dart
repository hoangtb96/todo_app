import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/extensions/string_extension.dart';
import 'package:todo_app/module/note/arguments/add_todo_arguments.dart';
import 'package:todo_app/module/note/bloc/todo_bloc.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/event/update_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/routes/routes_name.dart';

class TodoTile extends StatelessWidget {
  final VoidCallback updateTodos;
  final Todo todo;
  final ToDoBloc bloc;
  final ListLevel listLevel;

  const TodoTile({
    required this.updateTodos,
    required this.todo,
    required this.bloc,
    required this.listLevel,
  });

  @override
  Widget build(BuildContext context) {
    final TextDecoration completedTextDecoration =
        !todo.completed ? TextDecoration.none : TextDecoration.lineThrough;
    return ListTile(
      key: Key(todo.id.toString()),
      title: Text(
        todo.name,
        style: TextStyle(
          fontSize: Constants.sizeTextTitleGroup,
          decoration: completedTextDecoration,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            '${DateFormat.MMMMEEEEd().format(todo.date)} • ',
            style: TextStyle(
              height: 1.3,
              decoration: completedTextDecoration,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2.5,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: _getColor(),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Text(
              EnumToString.convertToString(todo.priorityLevel).capitalize(),
              style: TextStyle(
                color: !todo.completed ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                decoration: completedTextDecoration,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        value: todo.completed,
        activeColor: _getColor(),
        onChanged: (value) {
          bloc.event
              .add(UpdateTodoEvent(todo: todo.copyWith(completed: value)));
          updateTodos();
        },
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteName.toDoCreatePage,
            arguments: AddTodoArguments(
                todo: todo,
                updateTodos: () {
                  bloc.event.add(
                    ListToDoEvent(listLevel: listLevel),
                  );
                }));
      },
    );
  }

  Color _getColor() {
    switch (todo.priorityLevel) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.medium:
        return Colors.orange[600]!;
      case PriorityLevel.high:
        return Colors.red[400]!;
    }
  }
}
