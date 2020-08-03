import 'dart:ui';

import 'package:flutter/material.dart';

const primaryColor = const Color.fromRGBO(87, 134, 255, 1.0);
const primaryLight = const Color.fromRGBO(173, 232, 244, 1.0);
const primaryDark = const Color.fromRGBO(2, 62, 138, 1.0);

const primaryGradient = const LinearGradient(
  colors: const [primaryLight, primaryColor],
  stops: const [0.0, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
