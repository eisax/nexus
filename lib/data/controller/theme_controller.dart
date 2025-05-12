import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/styles/theme.dart';
import 'package:nexus/utils/labelKeys.dart' as SharedPreferenceHelper;
import 'package:nexus/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  void _loadCurrentTheme() {
    print("Current Theme $darkTheme");

    _darkTheme = sharedPreferences.getBool(SharedPreferenceHelper.theme) ?? true;

    update();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(SharedPreferenceHelper.theme, _darkTheme);
    if (_darkTheme) {
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(AppTheme.darkThemeData);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(AppTheme.lightThemeData);
    }

    _loadCurrentTheme();
    MyUtils.allScreen();
    update();
  }
}
