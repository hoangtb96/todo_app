import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/module/note/arguments/add_todo_arguments.dart';
import 'package:todo_app/module/note/page/todo_create_page.dart';
import 'package:todo_app/module/note/repo/todo_repo.dart';
import 'package:todo_app/routes/routes_name.dart';
import 'package:todo_app/service/database_service.dart';
import 'package:todo_app/tab/tab_controller.dart';
import 'package:todo_app/widgets/base_widget.dart';

class Routes {
  static Route authorizedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.toDoListPage:
        return _buildRoutes(settings, const TabPageController());
      case RouteName.toDoCreatePage:
        final args = settings.arguments as AddTodoArguments;
        return _buildRoutes(
            settings,
            PageContainer(
              child: AddToDoPage(
                updateTodos: args.updateTodos,
                todo: args.todo,
              ),
              actions: [],
              di: [
                Provider.value(value: DatabaseService()),
                ProxyProvider<DatabaseService, TodoRepo>(
                    update: (context, dbService, previous) =>
                        TodoRepo(dbService: dbService))
              ],
              bloc: [],
              hasBloc: true,
            ));
      default:
        return _buildErrorRoutes();
    }
  }

  static Route _buildRoutes(RouteSettings settings, Widget page) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static Route _buildErrorRoutes() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Comming soon'),
        ),
      );
    });
  }
}
