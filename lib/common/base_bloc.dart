import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'base_event.dart';

abstract class BaseBloc {
  final StreamController<BaseEvent> _eventStreamController =
      StreamController<BaseEvent>();
  final StreamController<BaseEvent> _processEventSubject =
      BehaviorSubject<BaseEvent>();
  final StreamController<bool> _loadingStreamController =
      StreamController<bool>();

  Stream<bool> get loadingStream => _loadingStreamController.stream;
  Sink<bool> get loadingSink => _loadingStreamController.sink;

  Stream<BaseEvent> get processEventStream => _processEventSubject.stream;
  Sink<BaseEvent> get processEventSink => _processEventSubject.sink;

  Sink<BaseEvent> get event => _eventStreamController.sink;

  BaseBloc() {
    _eventStreamController.stream.listen((event) {
      if (event is! BaseEvent) {
        throw Exception("Invalid event");
      }

      dispatchEvent(event);
    });
  }

  Future<void> dispatchEvent(BaseEvent event);

  @mustCallSuper
  void disposeBloc() {
    _eventStreamController.close();
    _processEventSubject.close();
    _loadingStreamController.close();
  }
}
