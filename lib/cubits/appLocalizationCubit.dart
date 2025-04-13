import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/data/repositories/settingsRepository.dart';

class AppLocalizationState {
  final Locale language;
  AppLocalizationState(this.language);
}


class AppLocalizationCubit extends Cubit<AppLocalizationState>{
  final SettingsRepository _settingsRepository;
  AppLocalizationCubit(this._settingsRepository):super;
}

