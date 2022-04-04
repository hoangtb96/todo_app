import 'package:todo_app/common/base_event.dart';

class ErrorMsgEvent extends BaseEvent {
  final String errorMsg;
  ErrorMsgEvent(this.errorMsg);
}
