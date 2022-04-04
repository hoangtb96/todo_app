import 'package:flutter/material.dart';
import 'package:todo_app/constants/constants.dart';

// Created by HoangTB-20/4/2021
class CustomAlert extends StatelessWidget {
  final String title;
  final String content;
  final Function pressOK;

  const CustomAlert(
      {Key? key,
      required this.title,
      required this.content,
      required this.pressOK})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontSize: Constants.sizeTextTitlePopup),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: Constants.sizeTextContent),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        TextButton(
          child: const Text(
            "Xác nhận",
            style: TextStyle(fontSize: Constants.sizeTextContent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            pressOK();
          },
        ),
      ],
    );
  }
}
