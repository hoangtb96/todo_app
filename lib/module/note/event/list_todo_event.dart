import 'package:todo_app/common/base_event.dart';

enum ListLevel { all, complete, incomplete }

class ListToDoEvent extends BaseEvent {
  final ListLevel listLevel;

  ListToDoEvent({required this.listLevel});
}
