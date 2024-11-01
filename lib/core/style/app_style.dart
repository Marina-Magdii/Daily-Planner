import 'package:daily_planner/core/style/colors_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static ThemeData lightTheme=ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey,secondary: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 20,
        shadowColor: Colors.black,
        backgroundColor: ColorsManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r)
        ),
        textStyle: TextStyle(
          color: Colors.white,
          fontFamily: StringsManager.fontFamily,
          fontSize: 20.sp,
        )
      )
    ),
    scaffoldBackgroundColor: ColorsManager.bg,
      textTheme: TextTheme(
      titleLarge: TextStyle(
      fontFamily: StringsManager.fontFamily,
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
        color: ColorsManager.secondary
  ),
      titleMedium: TextStyle(
        fontFamily: StringsManager.fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
      fontFamily: StringsManager.fontFamily,
        fontSize: 20.sp,
        color: ColorsManager.secondary
  ),
  )
  );
}