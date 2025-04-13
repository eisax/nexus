import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/utils/labelKeys.dart';
import 'package:nexus/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Widget routeInstance() {
    return SplashScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    navigateToNextScreen();
    super.initState();
  }

  void navigateToNextScreen() async {
    Get.offNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(Utils.getTranslatedLabel(selectAnyKey))),
    );
  }
}
