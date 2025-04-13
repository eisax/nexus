import 'package:flutter/material.dart';

class AppLocalizationState {
  final Locale language;
  AppLocalizationState(this.language);
}


class AppLocalizationCubit extends Cubit<AppLocalizationState> {