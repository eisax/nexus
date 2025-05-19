import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';

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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    navigateToNextScreen();
  });
  }

  void navigateToNextScreen() {
    Get.offNamed(RouteHelper.navigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: const Color(0xFFFFFFFF),
        child: InkWell(
          child: Stack(
            children: [
              Positioned.fill(
                top: Get.height / 2 - 72,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Hero(
                        tag: "splashscreenImage",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 62,
                            width: 62,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            child: Image.asset(
                              "assets/images/icon.png",
                              filterQuality: FilterQuality.low,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "NEXUS",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          color: Color(0xFF121212),
                          fontFamily: "assets/fonts/tg_type_bold.otf",
                          letterSpacing: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 51.0),
                    child: Text(
                      "@Copyright2025 nexus.co.zw",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.0,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
