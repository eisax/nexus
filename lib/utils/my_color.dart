import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/data/controller/theme_controller.dart';

class MyColor {
  //Primary Color Pallet based on shades
  static const Color primaryColor50 = Color(0xffeef8ff);
  static const Color primaryColor100 = Color(0xffd8eeff);
  static const Color primaryColor200 = Color(0xffb9e0ff);
  static const Color primaryColor300 = Color(0xff89cfff);
  static const Color primaryColor400 = Color(0xff52b4ff);
  static const Color primaryColor500 = Color(0xff5f67fc);
  static const Color primaryColor600 = Color(0xff0d6efd);
  static const Color primaryColor700 = Color(0xff0c5ae9);
  static const Color primaryColor800 = Color(0xff144194);
  static const Color primaryColor900 = Color(0xff144194);
  static const Color primaryColor950 = Color(0xff11295a);

  //Secondary Color Pallet  based on shades
  static const Color secondaryColor50 = Color(0xffF8FAFC);
  static const Color secondaryColor100 = Color(0xffF1F5F9);
  static const Color secondaryColor200 = Color(0xffE2E8F0);
  static const Color secondaryColor300 = Color(0xffCBD5E1);
  static const Color secondaryColor400 = Color(0xff94A3B8);
  static const Color secondaryColor500 = Color(0xff64748B);
  static const Color secondaryColor600 = Color(0xff475569);
  static const Color secondaryColor700 = Color(0xff334155);
  static const Color secondaryColor800 = Color(0xff1E293B);
  static const Color secondaryColor900 = Color(0xff0F172A);
  static const Color secondaryColor950 = Color(0xff020617);
  // static const Color secondaryColor950 = Color(0xff202630);

  //BG COLOR
  static const Color screenBackgroundColorDark = secondaryColor950;
  static const Color screenBackgroundColorLight = secondaryColor50;

//Color Theming
  static Color getScreenBgColor() {
    return Get.find<ThemeController>().darkTheme ? secondaryColor950 : secondaryColor50;
  }

  static bool checkIsDarkTheme() {
    return Get.find<ThemeController>().darkTheme;
  }

  static Color getScreenBgSecondaryColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? secondaryColor900
            : secondaryColor100
        : (!isReverse)
            ? secondaryColor100
            : secondaryColor900;
  }

  static Color getShadowColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? secondaryColor100
            : secondaryColor100
        : (!isReverse)
            ? primaryColor100
            : secondaryColor100;
  }

  static Color getPrimaryTextColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? secondaryColor50
            : secondaryColor900
        : (!isReverse)
            ? secondaryColor900
            : secondaryColor50;
  }

  static Color getSecondaryTextColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? secondaryColor300
            : secondaryColor600
        : (!isReverse)
            ? secondaryColor600
            : secondaryColor300;
  }

  static Color getPrimaryTextHintColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? grayColor1 : grayColor1;
  }

  //TAbBAR
  static Color getTabBarTabBackgroundColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor900 : secondaryColor100;
  }

  static Color getTabBarTabColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor800 : secondaryColor200;
  }

  //AppBar
  static Color getAppBarBackgroundColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor900 : secondaryColor100;
  }

  static Color getAppBarContentColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? secondaryColor300
            : secondaryColor600
        : (!isReverse)
            ? secondaryColor600
            : secondaryColor300;
  }

  static Color getAppBarColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor800 : secondaryColor200;
  }

  //Text Field
  static Color getTextFieldFillColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor900 : secondaryColor100;
  }

  static Color getTextSecondaryFieldFillColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor900 : secondaryColor100;
  }

  static Color getTextFieldHintColor() {
    return secondaryColor300;
  }

  static Color getTextFieldDisableBorder() {
    return textFieldDisableBorderColor;
  }

  static Color getTextFieldEnableBorder() {
    return textFieldEnableBorderColor;
  }

  //Text Field End

  //Border
  static Color getBorderColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor800 : secondaryColor200;
  }

  //System status bar and System Navigation Bar
  static Color getSystemStatusBarColor() {
    return Get.find<ThemeController>().darkTheme ? screenBackgroundColorDark : screenBackgroundColorLight;
  }

  static Brightness getSystemStatusBarBrightness() {
    return Get.find<ThemeController>().darkTheme ? Brightness.light : Brightness.dark;
  }

  static Color getSystemNavigationBarColor() {
    return Get.find<ThemeController>().darkTheme ? screenBackgroundColorDark : screenBackgroundColorLight;
  }

  static Brightness getSystemNavigationBarBrightness() {
    return Get.find<ThemeController>().darkTheme ? Brightness.light : Brightness.dark;
  }

  //Filter
  //Active
  static Color getFilterTapActionButtonBgColorActive({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor800 : secondaryColor200;
  }

  //Inactive
  static Color getFilterTapActionButtonBgColorInActive({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor900 : secondaryColor100;
  }

  //Shimmer
  static Color getShimmerBaseColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor900 : secondaryColor200;
  }

  static Color getShimmerHighLightColor({bool isReverse = false}) {
    return (Get.find<ThemeController>().darkTheme || isReverse == true) ? secondaryColor700 : secondaryColor300;
  }

  //OLD
  static const Color primaryColor = primaryColor500;
  static const Color primaryColorDark = primaryColor500;
  static const Color primaryColorLight = primaryColor950;
  static const Color primaryAccentColor = Color(0xffA855F7);
  static const Color borderColorLight = Color(0xFFE4E1E1);
  static const Color borderColorDark = Color(0xff454545);
  static const Color borderColor2 = Color(0xff3D3D3D);

  static const Color assetColorGray = Color(0xff555555);
  static const Color assetColorGray2 = Color(0xffF8FAFC);
  static const Color grayColor1 = Color(0xffB0B0B0);
  static const Color grayColor2 = Color(0xff242424);
  static const Color grayColor3 = Color(0xffF6F6F6);
  static const Color grayColor4 = Color(0xffD1D1D1);

  static const Color secondaryColor = Color(0xffF6F7FE);
  static const Color screenBgColor = Color(0xFFF9F9F9);
  static const Color primaryTextColor = Color(0xff262626);
  static const Color contentTextColor = Color(0xff777777);
  static const Color lineColor = Color(0xffECECEC);
  static const Color borderColor = Color(0xffD9D9D9);
  static const Color bodyTextColor = Color(0xFF747475);

  static const Color titleColor = Color(0xff373e4a);
  static const Color labelTextColor = Color(0xff444444);
  static const Color smallTextColor1 = Color(0xff555555);

  static const Color appBarColor = primaryColorDark;
  static const Color appBarContentColor = colorWhite;

  static const Color textFieldDisableBorderColor = Color(0xffCFCEDB);
  static const Color textFieldEnableBorderColor = primaryColor500;

  static const Color primaryButtonColor = primaryColor500;
  static const Color primaryButtonTextColor = colorWhite;
  static const Color secondaryButtonColor = colorWhite;
  static const Color secondaryButtonTextColor = colorBlack;

  static const Color iconColor = Color(0xff555555);
  static const Color filterEnableIconColor = primaryColorDark;
  static const Color filterIconColor = iconColor;

  static const Color colorWhite = Color(0xffFFFFFF);
  static const Color colorBlack = Color(0xff262626);
  static const Color colorGreen = Color(0xff0ECB81);
  // static const Color colorGreen = Color(0xff34C759);
  static const Color colorRed = Color(0xFFF6465D);
  // static const Color colorRed = Color(0xFFFF3B30);
  static const Color colorYellow = Color(0xFFFFCC00);
  static const Color colorBlue = Color(0xFF007AFF);
  static const Color colorGrey = Color(0xff555555);
  static const Color transparentColor = Colors.transparent;

  static const Color greenSuccessColor = greenP;
  static const Color redCancelTextColor = Color(0xFFF93E2C);
  static const Color highPriorityPurpleColor = Color(0xFF7367F0);
  static const Color pendingColor = Colors.orange;

  static const Color greenP = Color(0xFF28C76F);
  static const Color containerBgColor = Color(0xffF9F9F9);

  //zm
  static const Color ticketDateColor = Color(0xff888888);

  static Color getPrimaryAccentColor() {
    return Get.find<ThemeController>().darkTheme ? primaryAccentColor : primaryColorLight;
  }

  static Color getPrimaryColor() {
    return Get.find<ThemeController>().darkTheme ? primaryColor : primaryColor;
  }

  static Color getPrimaryTextColorDark() {
    return Get.find<ThemeController>().darkTheme ? MyColor.colorGrey : primaryColorDark;
  }

  static Color getPolicyPageButtonColor() {
    return Get.find<ThemeController>().darkTheme ? MyColor.colorGrey.withOpacity(0.5) : MyColor.colorGrey.withOpacity(0.1);
  }

  //Button

  static Color getPrimaryButtonBgColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? Colors.white
            : screenBackgroundColorDark
        : (!isReverse)
            ? screenBackgroundColorDark
            : Colors.white;
  }

  static Color getNavBarBorderColor() {
    return Get.find<ThemeController>().darkTheme ? borderColorDark : borderColorLight;
  }

  static Color getNavBarIconTextColorActive() {
    return Get.find<ThemeController>().darkTheme ? primaryColor500 : primaryColor500;
  }

  static Color getNavBarIconTextColorInActive() {
    return Get.find<ThemeController>().darkTheme ? secondaryColor300 : secondaryColor600;
  }

  static Color getNavBarBgColor() {
    return Get.find<ThemeController>().darkTheme ? screenBackgroundColorDark : screenBackgroundColorLight;
  }

  static Color getSelectedChipBgColor() {
    return Get.find<ThemeController>().darkTheme ? colorWhite : grayColor1.withOpacity(0.3);
  }

  static Color getSelectedChipTextColor() {
    return Get.find<ThemeController>().darkTheme ? colorWhite : grayColor1.withOpacity(0.3);
  }

  static Color getButtonColor() {
    return Get.find<ThemeController>().darkTheme ? colorWhite : grayColor1.withOpacity(0.3);
  }

  static Color getGreyText() {
    return MyColor.colorBlack.withOpacity(0.5);
  }

  static Color getAppBarContentTextColor() {
    return Get.find<ThemeController>().darkTheme ? colorWhite : screenBackgroundColorDark;
  }

  static Color getAppBarActionButtonColor() {
    return appBarContentColor;
  }

  static Color getHeadingTextColor() {
    return primaryTextColor;
  }

  static Color getContentTextColor() {
    return contentTextColor;
  }

  static Color getLabelTextColor({bool isReverse = false}) {
    return Get.find<ThemeController>().darkTheme
        ? (!isReverse)
            ? secondaryColor50
            : secondaryColor900
        : (!isReverse)
            ? secondaryColor900
            : secondaryColor50;
  }

  static Color getPrimaryButtonColor() {
    return primaryButtonColor;
  }

  static Color getPrimaryButtonTextColor() {
    return primaryButtonTextColor;
  }

  static Color getSecondaryButtonColor() {
    return secondaryButtonColor;
  }

  static Color getSecondaryButtonTextColor() {
    return secondaryButtonTextColor;
  }

  static Color getIconColor() {
    return iconColor;
  }

  static Color getFilterDisableIconColor() {
    return filterIconColor;
  }

  static Color getSearchEnableIconColor() {
    return colorRed;
  }

  static Color getTransparentColor() {
    return transparentColor;
  }

  static Color getCardBgColor() {
    return colorWhite;
  }

  static List<Color> symbolPlate = [
    const Color(0xffDE3163),
    const Color(0xffC70039),
    const Color(0xff900C3F),
    const Color(0xff581845),
    const Color(0xffFF7F50),
    const Color(0xffFF5733),
    const Color(0xff6495ED),
    const Color(0xffCD5C5C),
    const Color(0xffF08080),
    const Color(0xffFA8072),
    const Color(0xffE9967A),
    const Color(0xff9FE2BF),
  ];

  static getSymbolColor(int index) {
    int colorIndex = index > 10 ? index % 10 : index;
    return symbolPlate[colorIndex];
  }
}
