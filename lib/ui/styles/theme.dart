import 'package:flutter/material.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class AppTheme {
  static ThemeData lightThemeData = ThemeData(
    fontFamily: 'Inter',
    primaryColor: MyColor.primaryColor950,
    brightness: Brightness.light,
    // scaffoldBackgroundColor: MyColor.getScreenBgColor(),
    // hintColor: MyColor.getTextFieldHintColor(),
    buttonTheme: const ButtonThemeData(
      buttonColor: MyColor.primaryColor950,
    ),
    tabBarTheme: TabBarTheme(
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        // color: MyColor.getTabBarTabColor(),
        borderRadius: BorderRadius.circular(Dimensions.cardRadius1),
        border: Border.all(
          // color: MyColor.getTabBarTabColor(),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: semiBoldDefault.copyWith(
        fontSize: Dimensions.fontLarge,
      ),
      // unselectedLabelColor: MyColor.getSecondaryTextColor(),
      unselectedLabelStyle: regularLarge.copyWith(fontSize: Dimensions.fontLarge),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimensions.cardRadius2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space2, horizontal: Dimensions.space5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimensions.cardRadius2,
          ),
        ),
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space2, horizontal: Dimensions.space5),
      ),
    ),
    cardColor: MyColor.colorBlack,
    appBarTheme: AppBarTheme(backgroundColor: MyColor.primaryColor950, elevation: 0, titleTextStyle: regularLarge.copyWith(color: MyColor.colorWhite), iconTheme: const IconThemeData(size: 20, color: MyColor.colorWhite)),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(MyColor.colorBlack),
      fillColor: WidgetStateProperty.all(MyColor.primaryColor950),
    ),
  );

  static ThemeData darkThemeData = ThemeData(
    fontFamily: 'Inter',
    primaryColor: MyColor.primaryColor950,
    brightness: Brightness.dark,
    // scaffoldBackgroundColor: MyColor.getScreenBgColor(),
    // hintColor: MyColor.getTextFieldHintColor(),
    primaryTextTheme: const TextTheme(bodyLarge: boldLarge),
    buttonTheme: const ButtonThemeData(
      buttonColor: MyColor.primaryColor500,
    ),
    textTheme: const TextTheme(),
    tabBarTheme: TabBarTheme(
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        // color: MyColor.getTabBarTabColor(),
        borderRadius: BorderRadius.circular(Dimensions.cardRadius1),
        border: Border.all(
          // color: MyColor.getTabBarTabColor(),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      // labelColor: MyColor.getPrimaryTextColor(),
      labelStyle: semiBoldDefault.copyWith(
        fontSize: Dimensions.fontLarge,
      ),
      // unselectedLabelColor: MyColor.getSecondaryTextColor(),
      unselectedLabelStyle: regularLarge.copyWith(fontSize: Dimensions.fontLarge),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimensions.cardRadius2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space2, horizontal: Dimensions.space5),
      ),
    ),
    cardColor: MyColor.colorBlack,
    appBarTheme: AppBarTheme(backgroundColor: MyColor.colorWhite, elevation: 0, titleTextStyle: regularLarge.copyWith(color: MyColor.colorWhite), iconTheme: const IconThemeData(size: 20, color: MyColor.colorWhite)),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(MyColor.colorWhite),
      fillColor: WidgetStateProperty.all(MyColor.colorWhite),
      overlayColor: WidgetStateProperty.all(MyColor.colorGreen),
    ),
  );
}

String googleMapNightStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#263c3f"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6b9a76"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#38414e"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#212a37"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9ca5b3"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#1f2835"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#f3d19c"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2f3948"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#515c6d"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    }
  ]
  ''';
