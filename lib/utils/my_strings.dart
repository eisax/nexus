import 'package:nexus/data/models/appLanguage.dart';

class MyStrings {
  static const String appName = "Nexus";
  static const String lastName = "Last Name";
  static const String last = "Last";
  static const String showMore = "Show More";
    static const String attachment = "Attachment";
      static const String theme = "Theme";

  static RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static List<AppLanguage> myLanguages = [
    AppLanguage(languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}
