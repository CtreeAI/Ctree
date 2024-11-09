import 'package:ctree/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class LAppBarTheme {
  LAppBarTheme._();

  static AppBarTheme lightAppBarTheme = const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.white,
  );
  static AppBarTheme darkAppBarTheme = const AppBarTheme(
    backgroundColor: AppColors.black,
    foregroundColor: AppColors.black,
  );
}
