import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/module/note/event/list_todo_event.dart';
import 'package:todo_app/module/note/page/todo_list_page.dart';
import 'package:todo_app/module/note/repo/todo_repo.dart';
import 'package:todo_app/service/database_service.dart';
import 'package:todo_app/widgets/base_widget.dart';

class TabPageController extends StatefulWidget {
  const TabPageController({Key? key}) : super(key: key);

  @override
  _TabPageControllerState createState() => _TabPageControllerState();
}

class _TabPageControllerState extends State<TabPageController> {
  int currentTab = 0; // to keep track of active tab index
  // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final List<Widget> screens = [
    PageContainer(
      child: const ToDoListPage(
        listLevel: ListLevel.all,
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
    ),
    PageContainer(
      child: const ToDoListPage(
        listLevel: ListLevel.incomplete,
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
    ),
    PageContainer(
      child: const ToDoListPage(
        listLevel: ListLevel.complete,
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
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: screens[currentTab],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentTab = 0;
                      // _selectTab(pageKeys[0], 0);
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.list,
                        color: currentTab == 0 ? Colors.blue : Colors.grey,
                        size: 30,
                      ),
                      Text(
                        'List All',
                        style: TextStyle(
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(right: 10),
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentTab = 1;
                      // _selectTab(pageKeys[1], 1);
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.wysiwyg,
                        size: 30,
                        color: currentTab == 1 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        'Incomplete List',
                        style: TextStyle(
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentTab = 2;
                      // _selectTab(pageKeys[1], 1);
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.done_all,
                        size: 30,
                        color: currentTab == 2 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        'Complete list',
                        style: TextStyle(
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
