import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/base_bloc.dart';
import 'package:todo_app/common/base_event.dart';

class BlocListener<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final Function(BaseEvent event) listener;

  const BlocListener({
    Key? key,
    required this.child,
    required this.listener,
  }): super(key: key);

  @override
  _BlocListenerState createState() => _BlocListenerState<T>();
}

class _BlocListenerState<T> extends State<BlocListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var bloc = Provider.of<T>(context) as BaseBloc;
    bloc.processEventStream.listen(
      (event) {
        widget.listener(event);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<BaseEvent>.value(
      value: (Provider.of<T>(context) as BaseBloc).processEventStream,
      initialData: BaseEvent(),
      updateShouldNotify: (prev, current) {
        return false;
      },
      child: Consumer<BaseEvent>(
        builder: (context, event, child) {
          return Container(
            child: widget.child,
          );
        },
      ),
    );
  }
}
