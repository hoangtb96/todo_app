import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final bool hasBloc;

  final List<SingleChildWidget> bloc;
  final List<SingleChildWidget> di;
  final List<Widget> actions;

  // final String title;
  // final Widget floatingButton;
  // final bool hasAppBar;

  const PageContainer({
    Key? key,
    required this.bloc,
    required this.di,
    required this.actions,
    required this.child,
    // this.floatingButton,
    // this.title = '',
    // this.hasAppBar = true,
    this.hasBloc = false,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hasBloc) {
      return KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: MultiProvider(
          providers: [
            ...di,
            ...bloc,
          ],
          child: child,
        ),
      );
    }
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: child,
    );
  }
}
