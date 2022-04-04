import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/extensions/string_extension.dart';
import 'package:todo_app/module/note/model/todo_model.dart';

class PriorityDropdownButton extends StatefulWidget {
  final Todo todo;
  final Function(PriorityLevel priorityLevel) didChange;
  const PriorityDropdownButton(
      {Key? key, required this.todo, required this.didChange})
      : super(key: key);

  @override
  State<PriorityDropdownButton> createState() => _PriorityDropdownButtonState();
}

class _PriorityDropdownButtonState extends State<PriorityDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PriorityLevel>(
      value: widget.todo.priorityLevel,
      icon: const Icon(Icons.arrow_drop_down_circle),
      iconSize: 22.0,
      iconEnabledColor: Theme.of(context).primaryColor,
      items: PriorityLevel.values
          .map((priorityLevel) => DropdownMenuItem(
                value: priorityLevel,
                child: Text(
                  EnumToString.convertToString(priorityLevel).capitalize(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: Constants.sizeTextContent,
                  ),
                ),
              ))
          .toList(),
      style: const TextStyle(fontSize: Constants.sizeTextContent),
      decoration: const InputDecoration(labelText: 'Priority Level'),
      onChanged: (value) => setState(() {
        widget.didChange(value!);
      }),
    );
  }
}
