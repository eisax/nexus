import 'package:get/get.dart';
import 'package:nexus/ui/screens/home/homeScreen.dart';
import 'package:nexus/ui/screens/splashScreen.dart';

class Routes {
  static const String splash = "/splash";
  static const String home = "/";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
    GetPage(name: home, page: () => HomeScreen.routeInstance()),
  ];
}
