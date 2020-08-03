import 'package:flutter/material.dart';
import 'package:mellow_note/routing/routes.dart';
import 'package:mellow_note/screens/categoryScreen.dart';
import 'package:mellow_note/screens/homeScreen.dart';
import 'package:mellow_note/screens/splashScreen.dart';
import 'package:mellow_note/screens/taskScreen.dart';
import 'package:page_transition/page_transition.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final Map<String, dynamic> arguments = settings.arguments;
  switch (settings.name) {
    case splashViewRoute:
      return PageTransition(
        child: SplashScreen(),
        type: PageTransitionType.leftToRight,
      );
    case homeViewRoute:
      return PageTransition(
        child: HomeScreen(),
        type: PageTransitionType.leftToRight,
      );
    case collectionViewRoute:
      return PageTransition(
        child: CategoryScreen(
          title: arguments["title"],
        ),
        type: PageTransitionType.leftToRight,
      );
    case taskViewRoute:
      return PageTransition(
        child: TaskScreen(
          title: arguments["title"],
          previousScreen: arguments["previousScreen"],
        ),
        type: PageTransitionType.leftToRight,
      );
    default:
      return PageTransition(
        child: HomeScreen(),
        type: PageTransitionType.leftToRight,
      );
  }
}
