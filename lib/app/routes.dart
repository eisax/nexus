import 'package:get/get.dart';
import 'package:nexus/ui/screens/fullview/fullviewScreen.dart';
import 'package:nexus/ui/screens/home/home_screen.dart';
import 'package:nexus/ui/screens/mapview/widgets/mapViewWidget.dart';
import 'package:nexus/ui/screens/overview/overview_screen.dart';
import 'package:nexus/ui/screens/profileandsettings/profile_and_settings_screen.dart';
import 'package:nexus/ui/screens/scan/scan_screen.dart';
import 'package:nexus/ui/screens/splash.dart';

class RouteHelper {
  static const String splashScreen = "/splashScreen";
  static const String home = "/";
  static const String scan = "/scan";
  static const String overview = "/overview";
  static const String profileandsettings = "/profileandsettings";
  static const String mapview = "/mapview";
  static const String fullview = "/fullview";

  List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen.routeInstance()),
    GetPage(name: home, page: () => HomeScreen.routeInstance()),
    GetPage(name: scan, page: () => ScanScreen.routeInstance()),
    GetPage(name: overview, page: () => OverViewScreen.routeInstance()),
    GetPage(
      name: profileandsettings,
      page: () => ProfileAndSettingsScreen.routeInstance(),
    ),
    GetPage(name: mapview, page: () => MapViewScreenScreen.routeInstance()),
    GetPage(name: fullview, page: () => FullViewScreen.routeInstance()),
  ];
}
