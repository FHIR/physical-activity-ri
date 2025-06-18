import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/constant.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  scaffoldBackgroundColor: CColor.white,
  // backgroundColor: CColor.white,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: CColor.white,
    unselectedItemColor: CColor.black,
    selectedItemColor: CColor.black,
    elevation: 0,
  ),
  appBarTheme: const AppBarTheme(
    color: CColor.primaryColor,
    titleTextStyle: TextStyle(
      color: CColor.white,
      // fontSize: 23,
      fontFamily: Constant.fontFamilyPoppins,
      // fontWeight: FontWeight.w800
    ),
  ),
  fontFamily: 'Poppins',
  highlightColor: CColor.white,
  splashColor: CColor.transparent,
);
