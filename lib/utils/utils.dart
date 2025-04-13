import 'package:flutter/material.dart';

class Utils{
  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static String getTranslatedLabel(String labelKey) {
    return labelKey.tr.trim();
  }
}