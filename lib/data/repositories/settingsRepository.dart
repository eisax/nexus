class SettingsRepository {
  Future<void> setCurrentLanguageCode(String value) async {
    Hive.box(settingsBoxKey).put(currentLanguageCodeKey, value);
  }

  Future<void> setAllowNotification(bool value) async {
    Hive.box(settingsBoxKey).put(allowNotificationKey, value);
  }
}
