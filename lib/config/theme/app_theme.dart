
import 'package:flutter/material.dart';

class AppTheme{
  ThemeData getTheme() => ThemeData(
    fontFamily: "Montserrat",
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 20, 167, 175),
    brightness: Brightness.dark
  );
}
