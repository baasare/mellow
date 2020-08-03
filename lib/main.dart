import 'package:flutter/material.dart';
import 'package:mellow_note/routing/router.dart' as router;
import 'package:mellow_note/routing/routes.dart';
import 'package:mellow_note/theme.dart';

void main() {
//  SystemChrome.setSystemUIOverlayStyle(
//    SystemUiOverlayStyle(statusBarColor: primaryDark),
//  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mellow Note',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      onGenerateRoute: router.generateRoute,
      initialRoute: splashViewRoute,
    );
  }
}