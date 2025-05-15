import 'package:get/get.dart';
import 'package:nexus/ui/screens/fullview/fullviewScreen.dart';
import 'package:nexus/ui/screens/home/home_screen.dart';
import 'package:nexus/ui/screens/mapview/widgets/mapViewWidget.dart';
import 'package:nexus/ui/screens/mapview/widgets/pickLocationScreen.dart';
import 'package:nexus/ui/screens/notifications/notification_screen.dart';
import 'package:nexus/ui/screens/overview/overview_screen.dart';
import 'package:nexus/ui/screens/profileandsettings/profile_and_settings_screen.dart';
import 'package:nexus/ui/screens/profileandsettings/widgets/devicemanagemnet/addDeviceScreen.dart';
import 'package:nexus/ui/screens/profileandsettings/widgets/devicemanagemnet/selectDeviceScreen.dart';
import 'package:nexus/ui/screens/profileandsettings/widgets/generalScreen.dart';
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
  static const String general = "/general";
  static const String adddevice = "/adddevice";
  static const String selectdevice = "/selectdevice";
  static const String notification = "/notification";
  static const String picklocation = "/picklocation";

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
    GetPage(name: general, page: () => GeneralScreen.routeInstance()),
    GetPage(name: adddevice, page: () => AddDeviceScreen.routeInstance()),
    GetPage(name: selectdevice, page: () => SelectDeviceScreen.routeInstance()),
    GetPage(name: notification, page: () => NotificationScreen.routeInstance()),
    GetPage(name: picklocation, page: () => PickLocationScreen.routeInstance()),
  ];
}
