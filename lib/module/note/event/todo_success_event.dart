import 'package:todo_app/common/base_event.dart';

class TodoSuccessEvent extends BaseEvent {
   final int todoID;
  TodoSuccessEvent({required this.todoID});
}
