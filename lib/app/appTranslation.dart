import 'package:nexus/utils/appLanguages.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = Map.fromEntries(
    appLanguages
        .map((appLanguage) => appLanguage.languageCode)
        .toList()
        .map(
          (languageCode) =>
              MapEntry(languageCode, Map<String, String>.from({})),
        ),
  );
}
