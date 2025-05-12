import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexus/utils/environment.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_strings.dart';
import 'package:vibration/vibration.dart';

class MyUtils {
  static splashScreen() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MyColor.getSystemStatusBarColor(),
        statusBarIconBrightness: MyColor.getSystemStatusBarBrightness(),
        systemNavigationBarColor: MyColor.getSystemStatusBarColor(),
        systemNavigationBarIconBrightness:
            MyColor.getSystemNavigationBarBrightness(),
      ),
    );
  }

  static allScreen() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MyColor.getSystemStatusBarColor(),
        statusBarIconBrightness: MyColor.getSystemStatusBarBrightness(),
        systemNavigationBarColor: MyColor.getSystemNavigationBarColor(),
        systemNavigationBarIconBrightness:
            MyColor.getSystemNavigationBarBrightness(),
      ),
    );
  }

  static dynamic getShadow() {
    return [
      BoxShadow(
        blurRadius: 15.0,
        offset: const Offset(0, 25),
        color: Colors.grey.shade500.withOpacity(0.6),
        spreadRadius: -35.0,
      ),
    ];
  }

  static dynamic getBottomNavShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 0),
      ),
    ];
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static vibrationOn() async {
    try {
      if (Environment.APP_VIBRATION) {
        if (await Vibration.hasVibrator() == true) {
          Vibration.vibrate(duration: 200);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static getOperationTitle(String value) {
    String number = value;
    RegExp regExp = RegExp(r'^(\d+)(\w+)$');
    Match? match = regExp.firstMatch(number);
    if (match != null) {
      String? num = match.group(1) ?? '';
      String? unit = match.group(2) ?? '';
      String title = '${MyStrings.last.tr} $num ${unit.capitalizeFirst}';
      return title.tr;
    } else {
      return value.tr;
    }
  }

  static String formatNumberAbbreviated(String numberValue) {
    try {
      double number = double.parse(numberValue.toString());
      if (number >= 1e9) {
        return '${(number / 1e9).toStringAsFixed(2)}B';
      } else if (number >= 1e6) {
        return '${(number / 1e6).toStringAsFixed(2)}M';
      } else if (number >= 1e3) {
        return '${(number / 1e3).toStringAsFixed(2)}K';
      } else {
        return number.toStringAsFixed(2);
      }
    } catch (e) {
      print(e.toString());
      return "0.0";
    }
  }

  static bool isFileTypeImage(String img) {
    try {
      String type = img.split('.').last.toLowerCase();
      if (type == "png") {
        return true;
      } else if (type == "jpg") {
        return true;
      } else if (type == "jpeg") {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static TextInputType getInputTextFieldType(String type) {
    if (type == "email") {
      return TextInputType.emailAddress;
    } else if (type == "number") {
      return TextInputType.number;
    } else if (type == "url") {
      return TextInputType.url;
    }
    return TextInputType.text;
  }

  static bool getInputType(String type) {
    if (type == "text") {
      return true;
    } else if (type == "email") {
      return true;
    } else if (type == "number") {
      return true;
    } else if (type == "url") {
      return true;
    }
    return false;
  }
}
