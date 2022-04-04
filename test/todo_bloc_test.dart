import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/module/note/bloc/todo_bloc.dart';
import 'package:todo_app/module/note/event/add_todo_event.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/event/update_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/module/note/repo/todo_repo.dart';
import 'package:todo_app/service/database_service.dart';

// Mock database service for testing
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late ToDoBloc bloc;
  late TodoRepo repo;
  late MockDatabaseService mockDatabaseService;
  late ListToDoEvent listAllEvent;
  late ListToDoEvent listIncompletedvent;
  late ListToDoEvent listCompletedEvent;

  late AddTodoEvent addTodoEvent;
  late UpdateTodoEvent updateTodoEvent;

  // initial
  setUp(() {
    mockDatabaseService = MockDatabaseService();
    repo = TodoRepo(dbService: mockDatabaseService);
    bloc = ToDoBloc(todoRepo: repo);
    listAllEvent = ListToDoEvent(listLevel: ListLevel.all);
    listIncompletedvent = ListToDoEvent(listLevel: ListLevel.incomplete);
    listCompletedEvent = ListToDoEvent(listLevel: ListLevel.complete);

    addTodoEvent = AddTodoEvent(
        todo: Todo(
            id: 100,
            name: 'test',
            date: DateTime.now(),
            priorityLevel: PriorityLevel.medium,
            completed: false));

    updateTodoEvent = UpdateTodoEvent(
        todo: Todo(
            id: 100,
            name: 'test',
            date: DateTime.now(),
            priorityLevel: PriorityLevel.medium,
            completed: false));
  });

  group('todo business logic test', () {
    final todosListFromService = [
      Todo(
              id: 1,
              name: 'test',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.medium,
              completed: false)
          .toMap(),
      Todo(
              id: 2,
              name: 'test 2',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.medium,
              completed: true)
          .toMap(),
      Todo(
              id: 3,
              name: 'test 3',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.medium,
              completed: false)
          .toMap(),
    ];

    final imcompleteListFromService = [
      Todo(
              id: 1,
              name: 'test',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.medium,
              completed: false)
          .toMap(),
      Todo(
              id: 3,
              name: 'test 3',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.medium,
              completed: false)
          .toMap(),
    ];

    final completeListFromService = [
      Todo(
              id: 2,
              name: 'test 2',
              date: DateTime.now(),
              priorityLevel: PriorityLevel.medium,
              completed: true)
          .toMap(),
    ];

    void arrangeDatabaseServiceReturnTodoListAll() {
      when(() => mockDatabaseService.getTodoListAll()).thenAnswer(
        (_) async => todosListFromService,
      );
    }

    void arrangeDatabaseServiceReturnIncompleteTodoList() {
      when(() => mockDatabaseService.getTodoListIncomplete()).thenAnswer(
        (_) async => imcompleteListFromService,
      );
    }

    void arrangeDatabaseServiceReturnCompleteTodoList() {
      when(() => mockDatabaseService.getTodoListComplete()).thenAnswer(
        (_) async => completeListFromService,
      );
    }

    void arrangeDatabaseServiceReturnAddedTodo() {
      when(() => mockDatabaseService.insert(addTodoEvent.todo.toMap()))
          .thenAnswer(
        (_) async => 100,
      );
    }

    void arrangeDatabaseServiceReturnUpdatedTodo() {
      when(() => mockDatabaseService.update(
          updateTodoEvent.todo.toMap(), updateTodoEvent.todo.id!)).thenAnswer(
        (_) async => 100,
      );
    }

    test('get todo list all', () async {
      arrangeDatabaseServiceReturnTodoListAll();
      bloc.dispatchEvent(listAllEvent);
      verify(() => mockDatabaseService.getTodoListAll()).called(1);
    });

    test('get todo incomplete list', () async {
      arrangeDatabaseServiceReturnIncompleteTodoList();
      bloc.dispatchEvent(listIncompletedvent);
      verify(() => mockDatabaseService.getTodoListIncomplete()).called(1);
    });

    test('get todo complete list', () async {
      arrangeDatabaseServiceReturnCompleteTodoList();
      bloc.dispatchEvent(listCompletedEvent);
      verify(() => mockDatabaseService.getTodoListComplete()).called(1);
    });

    test('add todo', () async {
      arrangeDatabaseServiceReturnAddedTodo();
      bloc.dispatchEvent(addTodoEvent);
      verify(() => mockDatabaseService.insert(addTodoEvent.todo.toMap()))
          .called(1);
    });

    test('update todo', () async {
      arrangeDatabaseServiceReturnUpdatedTodo();
      bloc.dispatchEvent(updateTodoEvent);
      verify(() => mockDatabaseService.update(
          updateTodoEvent.todo.toMap(), addTodoEvent.todo.id!)).called(1);
    });

    test('indicates loading list all', () async {
      arrangeDatabaseServiceReturnTodoListAll();
      final future = bloc.dispatchEvent(listAllEvent);
      await future;
      expect(bloc.todos.map((e) => e.toMap()), todosListFromService);
    });

    test('indicates loading list incomplete', () async {
      arrangeDatabaseServiceReturnIncompleteTodoList();
      final future = bloc.dispatchEvent(listIncompletedvent);
      await future;
      expect(bloc.todos.map((e) => e.toMap()), imcompleteListFromService);
    });

    test('indicates loading list complete', () async {
      arrangeDatabaseServiceReturnCompleteTodoList();
      final future = bloc.dispatchEvent(listCompletedEvent);
      await future;
      expect(bloc.todos.map((e) => e.toMap()), completeListFromService);
    });

    test('indicates processing add todo', () async {
      arrangeDatabaseServiceReturnAddedTodo();
      final future = bloc.dispatchEvent(addTodoEvent);
      await future;
      expect(bloc.todoID, 100);
    });

    test('indicates processing update todo', () async {
      arrangeDatabaseServiceReturnUpdatedTodo();
      final future = bloc.dispatchEvent(updateTodoEvent);
      await future;
      expect(bloc.todoID, 100);
    });
  });
}
