import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';

class ThemeApp {
  static Paleta paleta = Paleta();

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: paleta.grey900,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
  );
}
