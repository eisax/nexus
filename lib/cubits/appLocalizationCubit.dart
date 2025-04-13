import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLocalizationState {
  final Locale language;
  AppLocalizationState(this.language);
}


class AppLocalizationCubit extends Cubit<AppLocalizationState>{

  final SettingsRepository _settingsRepository;
  
  AppLocalizationCubit(super.initialState);
}

