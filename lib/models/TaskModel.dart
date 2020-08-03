import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// database table and column names
final String tableTask = 'tasks';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnCategory = 'category';
final String columnDueDate = 'dueDate';
final String columnCompleted = 'completed';

// task model class, manages the time tracked for a users' ride
class Task {
  int id;
  String title;
  String category;
  String dueDate;
  bool completed;

  Task(this.title, this.category, this.dueDate, this.completed, {this.id});

  // convenience constructor to create a Time object
  Task.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    category = map[columnCategory];
    dueDate = map[columnDueDate];
    completed = map[columnCompleted] == 1;
  }

  // convenience method to create a Map from this Time object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnCategory: category,
      columnDueDate: dueDate,
      columnCompleted: completed == true ? 1 : 0,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "taskDatabase.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableTask (
                $columnId INTEGER PRIMARY KEY,
                $columnTitle TEXT NOT NULL,
                $columnCategory TEXT NOT NULL,
                $columnDueDate TEXT NOT NULL,
                $columnCompleted INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  //  Insert data into the database
  Future<int> insert(Task task) async {
    Database db = await database;
    int id = await db.insert(tableTask, task.toMap());
    return id;
  }

  //  Get one data from the database
  Future<Task> queryTask(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableTask,
        columns: [
          columnId,
          columnTitle,
          columnCategory,
          columnDueDate,
          columnCompleted,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  //  Get all data from the database
  Future<List> queryAllTasks(String dbTable, List columnNames) async {
    Database db = await database;
//    var result = await db.rawQuery("SELECT * FROM $dbTable");

    var result = await db.query(dbTable,
        columns: columnNames,
        );

    return result.toList();
  }

  //  Get all data from the database where category is some string
  Future<List> queryCategory(
      String dbTable, List columnNames, String category) async {
    Database db = await database;

    var result = await db.query(dbTable,
        columns: columnNames,
        where: '$columnCategory = ?',
        whereArgs: [category]);

//    var result = await db.rawQuery(
//        "SELECT * FROM $dbTable WHERE $columnCategory =?", [category]);
    return result.toList();
  }

  //  Update data from the database using id
  Future<int> update(Task task) async {
    Database db = await database;
    return await db.update(tableTask, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

  //  Delete data from the database using id
  Future<List> deleteTask(dynamic id) async {
    Database db = await this.database;
    db.delete(tableTask, where: '$columnId = ?', whereArgs: [id]);
    return null;
  }
}
