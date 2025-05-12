import 'dart:convert';
import 'package:get/get.dart';
import 'package:nexus/data/controller/localization_controller.dart';
import 'package:nexus/utils/shared_preference_helper.dart';

class SplashController extends GetxController {
  LocalizationController localizationController;

  SplashController({required this.localizationController});

  bool isLoading = true;

  bool noInternet = false;
}


