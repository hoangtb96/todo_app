import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/base_event.dart';
import 'package:todo_app/common/error_msg_event.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/module/note/bloc/todo_bloc.dart';
import 'package:todo_app/module/note/component/priority_dropdown_button.dart';
import 'package:todo_app/module/note/event/add_todo_event.dart';
import 'package:todo_app/module/note/event/todo_success_event.dart';
import 'package:todo_app/module/note/event/update_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/widgets/bloc_listener.dart';
import 'package:todo_app/widgets/custom_alert.dart';

class AddToDoPage extends StatefulWidget {
  final VoidCallback updateTodos;
  final Todo? todo;

  const AddToDoPage({
    Key? key,
    required this.updateTodos,
    this.todo,
  }) : super(key: key);

  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Todo? _todo;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _todo = widget.todo;
    } else {
      _todo = Todo(
        name: '',
        date: DateTime.now(),
        priorityLevel: PriorityLevel.medium,
        completed: false,
      );
    }

    _nameController = TextEditingController(text: _todo!.name);
    _dateController =
        TextEditingController(text: DateFormat.MMMMEEEEd().format(_todo!.date));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!_isEditing ? 'Add Todo' : 'Update Todo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 40.0,
        ),
        child: ChangeNotifierProvider.value(
          value: ToDoBloc(todoRepo: Provider.of(context)),
          child: Consumer<ToDoBloc>(builder: (context, bloc, child) {
            return BlocListener<ToDoBloc>(
              listener: _handleEvent,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style:
                          const TextStyle(fontSize: Constants.sizeTextContent),
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Please enter a name' : null,
                      onSaved: (value) => _todo = _todo!.copyWith(name: value),
                    ),
                    const SizedBox(height: 32.0),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      style:
                          const TextStyle(fontSize: Constants.sizeTextContent),
                      decoration: const InputDecoration(labelText: 'Date'),
                      onTap: _handleDatePicker,
                    ),
                    const SizedBox(height: 32.0),
                    PriorityDropdownButton(
                      todo: _todo!,
                      didChange: (priorityLevel) =>
                          _todo = _todo!.copyWith(priorityLevel: priorityLevel),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (!_isEditing) {
                            bloc.event.add(AddTodoEvent(todo: _todo!));
                          } else {
                            bloc.event.add(UpdateTodoEvent(todo: _todo!));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: !_isEditing ? Colors.green : Colors.orange,
                        minimumSize: const Size.fromHeight(45.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        !_isEditing ? 'Add' : 'Save',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: Constants.sizeTextContent,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20.0),
                    // if (_isEditing)
                    //   ElevatedButton(
                    //     onPressed: () {
                    //       DatabaseService.instance.delete(_todo!.id!);
                    //       widget.updateTodos();
                    //       Navigator.of(context).pop();
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       minimumSize: const Size.fromHeight(45.0),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20.0),
                    //       ),
                    //     ),
                    //     child: const Text(
                    //       'Delete',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 16.0,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _todo!.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() => _todo = _todo!.copyWith(date: date));
    }
  }

  _handleEvent(BaseEvent event) {
    if (event is ErrorMsgEvent) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlert(
                title: 'Lỗi', pressOK: () {}, content: event.errorMsg);
          });
    }

    if (event is TodoSuccessEvent) {
      showDialog(
          context: context,
          builder: (BuildContext contextAlert) {
            return CustomAlert(
                title: 'Thông báo',
                content: 'Xử lý thành công!',
                pressOK: () {
                  widget.updateTodos();
                  Navigator.of(context).pop();
                });
          });
    }
  }
}
