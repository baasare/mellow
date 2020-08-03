import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mellow_note/routing/routes.dart';
import 'package:mellow_note/utils/app_config.dart';
import 'package:mellow_note/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => onDoneLoading());
  }

  onDoneLoading() async {
    Navigator.pushReplacementNamed(context, homeViewRoute);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 30),
                  child: Image.asset(
                    AvailableImages.appLogo["assetPath"],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
