import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mellow_note/models/TaskModel.dart';
import 'package:mellow_note/routing/routes.dart';
import 'package:mellow_note/utils/app_config.dart';

class Collection {
  String title;
  IconData categoryIcon;
  List data;

  // Constructor, with syntactic sugar for assignment to members.
  Collection(this.title, this.categoryIcon, this.data);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper helper = DatabaseHelper.instance;

  bool _isGridView = true;
  String tableName = "tasks";
  List<String> columnNames = ["title"];

  final categories = [
    Collection("All", Feather.clipboard, []),
    Collection("Work", Feather.briefcase, []),
    Collection("Music", Feather.headphones, []),
    Collection("Travel", Ionicons.ios_airplane, []),
    Collection("Study", Feather.book, []),
    Collection("Home", Feather.home, []),
    Collection("Create", Ionicons.md_color_palette, []),
    Collection("Shopping", Feather.shopping_cart, []),
  ];

  _getCategories() async {
    var allTasks = await helper.queryAllTasks(
      tableName,
      columnNames,
    );
    setState(() {
      categories[0].data.addAll(allTasks);
    });

    for (int i = 1; i < categories.length; i++) {
      var allTasks = await helper.queryCategory(
        tableName,
        columnNames,
        categories[i].title,
      );
      setState(() {
        categories[i].data.addAll(allTasks);
      });
    }
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = IconButton(
      icon: _isGridView
          ? Icon(
              Icons.sort,
              size: 35.0,
              color: Colors.black,
            )
          : Icon(
              Feather.grid,
              size: 35.0,
              color: Colors.black,
            ),
      onPressed: () {
        setState(() {
          _isGridView = !_isGridView;
        });
      },
    );

    final pageTitle = Text(
      "Mellow",
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 30.0,
      ),
    );

    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        onPressed: () {
          Navigator.of(context).pushNamed(
            taskViewRoute,
            arguments: {
              "title": "Work",
              "previousScreen": collectionViewRoute,
            },
          );
        },
        tooltip: 'New Todo',
        backgroundColor: Color.fromRGBO(84, 131, 248, 1),
        child: Icon(Icons.add),
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 18.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: appBar,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 30.0, bottom: 30.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: pageTitle,
                    ),
                  ),
                ],
              ),
            ),
            _isGridView
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.0,
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, int index) {
                        final Color taskColor = Colors.primaries[
                            Random().nextInt(Colors.primaries.length)];

                        final category = categories[index];

                        return Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(collectionViewRoute, arguments: {
                              "title": category.title,
                              "numOfTasks": category.data.length,
                              "color": taskColor
                            }),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      category.categoryIcon,
                                      color: taskColor,
                                      size: 45.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          category.title,
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          category.data.length > 1
                                              ? category.data.length
                                                      .toString() +
                                                  " Tasks"
                                              : category.data.length
                                                      .toString() +
                                                  " Task",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: categories.length,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final Color taskColor = Colors.primaries[
                            Random().nextInt(Colors.primaries.length)];

                        final category = categories[index];

                        return Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(collectionViewRoute, arguments: {
                              "title": category.title,
                              "numOfTasks": category.data.length,
                              "color": taskColor
                            }),
                            leading: Icon(
                              category.categoryIcon,
                              color: taskColor,
                              size: 35.0,
                            ),
                            title: Text(
                              category.title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              category.data.length > 1
                                  ? category.data.length.toString() + " Tasks"
                                  : category.data.length.toString() + " Task",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                      childCount: categories.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
