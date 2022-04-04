import 'package:todo_app/common/base_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';

class AddTodoEvent extends BaseEvent {
  final Todo todo;
  AddTodoEvent({required this.todo});
}
