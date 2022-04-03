import 'package:flutter/material.dart';

const _colorScheme = ColorScheme.light(
  primary: Color(0xffb10c26),
  primaryContainer: Color(0xff9c0b21),
  secondary: Color(0xff000000),
  secondaryContainer: Color(0xff000000),
);

final lightTheme = ThemeData(
  primaryColor: _colorScheme.primary,
  colorScheme: _colorScheme
);

final darkTheme = ThemeData(
  primaryColor: _colorScheme.primary,
  colorScheme: ColorScheme.dark(
    primary: _colorScheme.primary,
    primaryContainer: _colorScheme.primaryContainer,
    secondary: _colorScheme.secondary,
    secondaryContainer: _colorScheme.secondaryContainer,
  )
);

final blackTheme = ThemeData(
  primaryColor: _colorScheme.primary,
  colorScheme: ColorScheme.dark(
    primary: _colorScheme.primary,
    primaryContainer: _colorScheme.primaryContainer,
    secondary: _colorScheme.secondary,
    secondaryContainer: _colorScheme.secondaryContainer,
    surface: Colors.black
  ),
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black
);
