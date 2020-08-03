import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:mellow_note/models/TaskModel.dart';

class TaskScreen extends StatefulWidget {
  final String title;
  final String previousScreen;

  const TaskScreen({Key key, this.title, this.previousScreen})
      : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final todoController = TextEditingController();

  final double listSpec = 5.0;
  String stateText;

  var format = DateFormat('MMMM d, ').add_Hm();
  DateTime _dateTime;
  String _category;

  static const categories = '''
[
    [
    "Work", 
    "Music", 
    "Travel", 
    "Study", 
    "Home", 
    "Create", 
    "Shopping"
    ]
]
    ''';

  @override
  void initState() {
    _dateTime = DateTime.now();
    _category = widget.title == null ? "All" : widget.title;
    super.initState();
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(
              Ionicons.ios_close,
              color: Colors.black,
              size: 35.0,
            ),
          ),
        ],
        title: Center(
            child: Text(
          "New Task",
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                child: Text(
                  "What are you planning?",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                textAlign: TextAlign.left,
                controller: todoController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 30.0, bottom: 10.0, left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 20,
                    ),
                    child: Icon(
                      FontAwesome5.bell,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        setState(
                          () {
                            _dateTime = date;
                          },
                        );
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      format.format(_dateTime),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FontAwesome.tags,
                      color: Colors.grey,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    onPressed: () {
                      showPickerModal(context);
                    },
                    child: Text(
                      _category,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    DatabaseHelper helper = DatabaseHelper.instance;
                    Task task = Task(todoController.text, _category,
                        _dateTime.toString(), false);
                    int id = await helper.insert(task);
                    Navigator.of(context).pushNamed(
                      widget.previousScreen,
                      arguments: {
                        "title": widget.title,
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).primaryColor,
                    height: 50.0,
                    child: Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showPickerModal(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(categories),
          isArray: true,
        ),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            String temp = picker.adapter.text;
            temp = temp.replaceAll("]", "");
            temp = temp.replaceAll("[", "");
            _category = temp;
          });
        }).showModal(this.context); //_scaffoldKey.currentState);
  }
}
