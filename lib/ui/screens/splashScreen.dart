import 'package:flutter/material.dart';
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

  void navigateToNextScreen()async {

    if (context.read<AuthCubit>().state is Unauthenticated) {
      Get.offNamed(Routes.auth);
    } else {
      if(await context.read<AuthCubit>().isTokenValidt()){
        Get.offNamed(
        (context.read<AuthCubit>().state as Authenticated).isStudent
            ? Routes.home
            : Routes.parentHome,
      );
      }else{
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(Utils.getTranslatedLabel(selectAnyKey))),
    );
  }
}
