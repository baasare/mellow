import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:mellow_note/models/TaskModel.dart';
import 'package:mellow_note/routing/routes.dart';

class Todo {
  int id;
  String title;
  bool completed;
  DateTime dueDate;

  // Constructor, with syntactic sugar for assignment to members.
  Todo(this.id, this.title, this.completed, this.dueDate);
}

class CategoryScreen extends StatefulWidget {
  final String title;

  const CategoryScreen({Key key, this.title}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<String> columnNames = ["_id", "title", "completed", "dueDate"];
  String tableName = "tasks";

  var currentDate = DateTime.now();
  var format = DateFormat('MMMM d, yyyy • ').add_Hm();
  List<Todo> _tasks = [];
  Color themeColor = Colors.blueAccent;

  Map<String, List<Todo>> allTask = {"Late": [], "Active": [], "Done": []};

  _getTasks() async {
    if (widget.title != "All") {
      var allTasks = await helper.queryCategory(
        tableName,
        columnNames,
        widget.title,
      );

      for (int i = 0; i < allTasks.length; i++) {
        _tasks.add(new Todo(
          allTasks[i].row[0],
          allTasks[i].row[1].toString(),
          allTasks[i].row[2] == 1 ? true : false,
          DateTime.parse(allTasks[i].row[3]),
        ));
      }
    } else {
      var allTasks = await helper.queryAllTasks(tableName, columnNames);

      for (int i = 0; i < allTasks.length; i++) {
        _tasks.add(new Todo(
          allTasks[i].row[0],
          allTasks[i].row[1].toString(),
          allTasks[i].row[2] == 1 ? true : false,
          DateTime.parse(allTasks[i].row[3]),
        ));
      }
    }

    setState(() {
      for (int i = 0; i < _tasks.length; i++) {
        if (_tasks[i].completed) {
          allTask["Done"].add(_tasks[i]);
        } else if (_tasks[i].dueDate.isBefore(currentDate)) {
          allTask["Late"].add(_tasks[i]);
        } else {
          allTask["Active"].add(_tasks[i]);
        }
      }
    });
  }

  _updateTaskStatus(Task task) async {
    int id = await helper.update(task);
  }

  _deleteTask(dynamic id) async {
    await helper.deleteTask(id);
  }

  @override
  void initState() {
    _getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(homeViewRoute),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                taskViewRoute,
                arguments: {
                  "title": widget.title.toString(),
                  "previousScreen": collectionViewRoute,
                },
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
    return Scaffold(
      backgroundColor: themeColor,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: appBar,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Feather.clipboard,
                        color: themeColor,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _tasks.length > 1
                          ? _tasks.length.toString() + " Tasks"
                          : _tasks.length.toString() + " Task",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, top: 30),
                        child: Text(
                          "Late",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allTask["Late"].length,
                        itemBuilder: (context, index) {
                          final item = allTask["Late"][index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Icon(
                                      Ionicons.ios_trash,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  allTask["Late"].removeAt(index);
                                  _tasks.remove(item);
                                });
                                _deleteTask(item.id);
                                print("${item.title} deleted");
                              },
                              child: CheckboxListTile(
                                value: item.completed,
                                onChanged: (bool value) {
                                  _updateTaskStatus(Task(
                                    item.title,
                                    widget.title,
                                    item.dueDate.toString(),
                                    value,
                                    id: item.id,
                                  ));

                                  setState(() {
                                    item.completed = value;
                                    allTask["Late"].removeAt(index);
                                    allTask["Done"].add(item);
                                  });
                                },
                                title: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  format.format(item.dueDate),
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, top: 50),
                        child: Text(
                          "Active",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allTask["Active"].length,
                        itemBuilder: (context, index) {
                          final item = allTask["Active"][index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Icon(
                                      Ionicons.ios_trash,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  allTask["Active"].removeAt(index);
                                  _tasks.remove(item);
                                });
                                _deleteTask(item.id);
                                print("${item.title} deleted");
                              },
                              child: CheckboxListTile(
                                value: item.completed,
                                onChanged: (bool value) {
                                  _updateTaskStatus(Task(
                                    item.title,
                                    widget.title,
                                    item.dueDate.toString(),
                                    value,
                                    id: item.id,
                                  ));

                                  setState(() {
                                    item.completed = value;
                                    allTask["Active"].removeAt(index);
                                    allTask["Done"].add(item);
                                  });
                                },
                                title: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  format.format(item.dueDate),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, top: 40),
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allTask["Done"].length,
                        itemBuilder: (context, index) {
                          final item = allTask["Done"][index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Icon(
                                      Ionicons.ios_trash,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  allTask["Done"].removeAt(index);
                                  _tasks.remove(item);
                                });
                                _deleteTask(item.id);
                                print("${item.title} deleted");
                              },
                              child: CheckboxListTile(
                                value: item.completed,
                                onChanged: (bool value) {
                                  _updateTaskStatus(Task(
                                    item.title,
                                    widget.title,
                                    item.dueDate.toString(),
                                    value,
                                    id: item.id,
                                  ));

                                  setState(() {
                                    item.completed = value;
                                    allTask["Done"].removeAt(index);

                                    if (item.dueDate.isBefore(currentDate)) {
                                      allTask["Late"].add(item);
                                    } else {
                                      allTask["Active"].add(item);
                                    }
                                  });
                                },
                                title: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.blue[300],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  format.format(item.dueDate),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
