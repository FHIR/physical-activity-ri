import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/color.dart';

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
  appBarTheme: AppBarTheme(
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
