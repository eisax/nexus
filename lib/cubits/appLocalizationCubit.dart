import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nexus/data/repositories/settingsRepository.dart';
import 'package:nexus/utils/utils.dart';

class AppLocalizationState {
  final Locale language;
  AppLocalizationState(this.language);
}


class AppLocalizationCubit extends Cubit<AppLocalizationState>{
  final SettingsRepository _settingsRepository;
  AppLocalizationCubit(this._settingsRepository):super(
    AppLocalizationState(
      Utils.getLocaleFromLanguageCode(
              _settingsRepository.getCurrentLanguageCode(),
            ),
    )
  );

  void changeLanguage(String languageCode) {
    _settingsRepository.setCurrentLanguageCode(languageCode);

    Get.updateLocale(Utils.getLocaleFromLanguageCode(languageCode));
    emit(AppLocalizationState(Utils.getLocaleFromLanguageCode(languageCode)));
  }
}

