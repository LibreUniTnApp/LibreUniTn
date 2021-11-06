import 'package:flutter/material.dart';

const _colorScheme = const ColorScheme.light(
  primary: Color(0xffb10c26),
  primaryVariant: Color(0xff9c0b21),
  secondary: Color(0xff000000),
  secondaryVariant: Color(0xff000000),
);

final lightTheme = ThemeData(
  primaryColor: _colorScheme.primary,
  colorScheme: _colorScheme
);

final darkTheme = ThemeData(
  primaryColor: _colorScheme.primary,
  colorScheme: ColorScheme.dark(
    primary: _colorScheme.primary,
    primaryVariant: _colorScheme.primaryVariant,
    secondary: _colorScheme.secondary,
    secondaryVariant: _colorScheme.secondaryVariant,
  )
);

final blackTheme = ThemeData(
  primaryColor: _colorScheme.primary,
  colorScheme: ColorScheme.dark(
    primary: _colorScheme.primary,
    primaryVariant: _colorScheme.primaryVariant,
    secondary: _colorScheme.secondary,
    secondaryVariant: _colorScheme.secondaryVariant,
    surface: Colors.black
  ),
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black
);
