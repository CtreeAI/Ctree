import 'package:ctree/core/styles/app_colors.dart';
import 'package:ctree/core/styles/theme/custom/appbar_theme.dart';
import 'package:ctree/core/styles/theme/custom/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: LAppBarTheme.lightAppBarTheme,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lightGreen),
    textTheme: AppTextTheme.whiteTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: LAppBarTheme.darkAppBarTheme,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: AppTextTheme.blackTheme,
  );
}
