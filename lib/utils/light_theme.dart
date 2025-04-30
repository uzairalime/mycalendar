import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'SF Pro Display',
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.black,
    secondary: Colors.white,
    background: Colors.white,
    surface: Colors.white,
    error: Colors.red,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.black,
    // elevation: 0,
    // scrimColor: Colors.black.withOpacity(0.5),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    actionTextColor: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),


    // bodyText1: TextStyle(color: Colors.black),
    // bodyText2: TextStyle(color: Colors.black),
  ),
  iconTheme: IconThemeData(color: Colors.blue),
);