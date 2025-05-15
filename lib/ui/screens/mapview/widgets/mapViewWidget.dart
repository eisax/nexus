import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/screens/fullview/fullviewScreen.dart';
import 'package:nexus/ui/screens/mapview/mapviewScreen.dart';
import 'package:nexus/ui/screens/mapview/widgets/customButtonWidget.dart';
import 'package:nexus/ui/screens/mapview/widgets/customIconButton.dart';
import 'package:nexus/ui/screens/mapview/widgets/dialogwidgets/introductionDialogWidget.dart';
import 'package:nexus/ui/screens/mapview/widgets/dialogwidgets/nameDialogWidget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';

class MapViewScreenScreen extends StatefulWidget {
  const MapViewScreenScreen({super.key});

  @override
  State<MapViewScreenScreen> createState() => _MapViewScreenScreenState();

  static Widget routeInstance() {
    return const MapViewScreenScreen();
  }
}

class _MapViewScreenScreenState extends State<MapViewScreenScreen> {
  @override
  Widget build(BuildContext context) {
    return const MapViewScreen();
  }
}

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with WidgetsBindingObserver {
  List<String> withdrawMethodList = [
    "Details",
    "Skin",
    "Hotspot",
    "Guide",
    "Filter",
  ];
  String selectedWithdrawMethod = "Details";

  setWithdrawMethod(String method) {
    setState(() {
      selectedWithdrawMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: SafeArea(
          child: Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    padding: EdgeInsets.all(Dimensions.space5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MyColor.assetColorGray2,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 3),
                                          spreadRadius: 10,
                                          blurRadius: 5,
                                          color: MyColor.borderColor
                                              .withOpacity(0.25),
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/left_arrow_simple.svg",
                                      fit: BoxFit.cover,
                                      color: Color(0xFF5b6368),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomButton(
                                  text: "Full Screen",
                                  icon: MyIcons.fullScreen,
                                  size: 12,
                                  color: MyColor.assetColorGray2,
                                  textColor: MyColor.getContentTextColor(),
                                  onPressed:
                                      () => Get.offNamed(RouteHelper.fullview),
                                ),
                                horizontalSpace(Dimensions.space15),
                                CustomButton(
                                  text: "Complete",
                                  icon: MyIcons.send,
                                  size: 12,
                                  color: Color(0xff2d71ff),
                                  textColor: MyColor.assetColorGray2,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.space15,
                            horizontal: Dimensions.space25,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimensions.space15 + Dimensions.space10,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.space10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 3),
                                    spreadRadius: 10,
                                    blurRadius: 5,
                                    color: MyColor.borderColor.withOpacity(
                                      0.25,
                                    ),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.space15,
                                ),
                                child: FullViewScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Upper Selection bar
                Container(
                  decoration: BoxDecoration(color: MyColor.getCardBgColor()),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Details
                      if (selectedWithdrawMethod == "Details") ...[
                        IconButtonWidget(
                          iconPath: "assets/images/interface/text.svg",
                          text: "Name",
                          color: Color(0xff5f67fc),
                          onTap: () {
                            CustomBottomSheetPlus(
                              child: UpdateProjectName(),
                              isNeedPadding: false,
                              borderRadius: 10,
                              bgColor: MyColor.transparentColor,
                            ).show(context);
                          },
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/list.svg",
                          text: "Introduction",
                          color: MyColor.getPrimaryColor(),
                          onTap: () {
                            CustomBottomSheetPlus(
                              child: UpdateProjectIntroduction(),
                              isNeedPadding: false,
                              borderRadius: 10,
                              bgColor: MyColor.transparentColor,
                            ).show(context);
                          },
                        ),
                        IconButtonWidget(
                          iconPath:
                              "assets/images/interface/location-point.svg",
                          text: "Location",
                          color: Color(0xffe87a65),
                          onTap: () {
                            Get.toNamed(RouteHelper.picklocation);
                          },
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/compass.svg",
                          text: "Compass",
                          color: Color(0xff63d3c9),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/user-id.svg",
                          text: "Contact",
                          color: Color(0xffe8b163),
                          onTap: () {},
                        ),
                      ],
                      // Skin
                      if (selectedWithdrawMethod == "Skin") ...[
                        IconButtonWidget(
                          iconPath: "assets/images/interface/initial-view.svg",
                          text: "Initial View",
                          color: MyColor.getPrimaryColor(),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/skin.svg",
                          text: "Skin",
                          color: Color(0xffe8b163),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/compass.svg",
                          text: "Point Style",
                          color: Color(0xff5f67fc),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/entry.svg",
                          text: "Entry",
                          color: Color(0xffe87a65),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/music.svg",
                          text: "Music",
                          color: Color(0xff63d3c9),
                          onTap: () {},
                        ),
                      ],
                      // Hotspot
                      if (selectedWithdrawMethod == "Hotspot") ...[
                        IconButtonWidget(
                          iconPath: "assets/images/interface/text.svg",
                          text: "Text",
                          color: Color(0xff5f67fc),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/graphic.svg",
                          text: "Graphic",
                          color: Color(0xffe8b163),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/video.svg",
                          text: "Video",
                          color: Color(0xff63d3c9),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/ruler.svg",
                          text: "Ruler",
                          color: MyColor.getPrimaryColor(),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/list.svg",
                          text: "Label List",
                          color: MyColor.getPrimaryColor(),
                          onTap: () {},
                        ),
                      ],
                      // Guide
                      if (selectedWithdrawMethod == "Guide") ...[
                        IconButtonWidget(
                          iconPath: "assets/images/interface/guide.svg",
                          text: "Guide",
                          color: MyColor.getPrimaryColor(),
                          onTap: () {},
                        ),
                      ],
                      // Filter
                      if (selectedWithdrawMethod == "Filter") ...[
                        IconButtonWidget(
                          iconPath: "assets/images/interface/user-id.svg",
                          text: "Filter",
                          color: Color(0xffe8b163),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/compass.svg",
                          text: "Blur",
                          color: Color(0xff63d3c9),
                          onTap: () {},
                        ),
                      ],
                    ],
                  ),
                ),
                // Lower selection bar
                SelectionBarWidget(
                  items: withdrawMethodList,
                  selectedItem: selectedWithdrawMethod,
                  onSelected: setWithdrawMethod,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
