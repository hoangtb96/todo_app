import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/app.dart' as app;

void main() {
  group('App test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Full app test', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final addFloatingBtn = find.byType(FloatingActionButton).first;
      await tester.tap(addFloatingBtn);
      await tester.pumpAndSettle();
      final nameTextFormField = find.byType(TextFormField).first;
      final createTodoBtn = find.byType(ElevatedButton).first;
      await tester.enterText(nameTextFormField, "Something todo");
      await tester.tap(createTodoBtn);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
