import 'package:todo_app/common/base_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';

class UpdateTodoEvent extends BaseEvent {
  final Todo todo;
  UpdateTodoEvent({required this.todo});
}