import 'package:get/get.dart';

class Routes {
  static const String splash = "/splash";
  static const String home = "/";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
  ];
}
