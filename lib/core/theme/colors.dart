import 'package:flutter/material.dart';

class AppColor {
  static final AppColor _singleton = AppColor._internal();

  factory AppColor() {
    return _singleton;
  }

  AppColor._internal();

// ##59022F
  static const Color primary = Color(0xFF59022F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF00FF00);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFC2185B);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF1F5FB);
  static const Color blackColor = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color tertiary = Color(0xFFB3E5FC);
  static const Color onTertiary = Color(0xFF000000);

  static const Color darkPrimary = Color(0xFF59022F);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFF00FF00);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkError = Color(0xFFC2185B);
  static const Color darkOnError = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkTertiary = Color(0xFFB3E5FC);
  static const Color darkOnTertiary = Color(0xFFFFFFFF);
}
