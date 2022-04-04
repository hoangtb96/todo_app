import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/model/todo_model.dart';
import 'package:todo_app/module/note/page/todo_list_page.dart';
import 'package:todo_app/module/note/repo/todo_repo.dart';
import 'package:todo_app/service/database_service.dart';
import 'package:todo_app/widgets/base_widget.dart';

// Mock database service for testing
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;
  setUp(() {
    mockDatabaseService = MockDatabaseService();
  });

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

  void arrangeDatabaseServiceReturnTodoListAll() {
    when(() => mockDatabaseService.getTodoListAll()).thenAnswer(
      (_) async => todosListFromService,
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
          primaryColor: Colors.deepOrange),
      home: PageContainer(
        child: const ToDoListPage(
          listLevel: ListLevel.all,
        ),
        actions: [],
        di: [
          Provider.value(value: TodoRepo(dbService: mockDatabaseService)),
        ],
        bloc: [],
        hasBloc: true,
      ),
    );
  }

  testWidgets('title is display', (WidgetTester tester) async {
    arrangeDatabaseServiceReturnTodoListAll();
    
    await tester.pumpWidget(createWidgetUnderTest());
    
    expect(find.text('My Todos'), findsOneWidget);
  });
}
