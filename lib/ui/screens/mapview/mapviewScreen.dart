import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';

// Reusable Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;
  final Color textColor;
  final double size;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onPressed,  this.size=24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.space12,
          vertical: Dimensions.space5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: color,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              spreadRadius: 10,
              blurRadius: 5,
              color: MyColor.borderColor.withOpacity(0.25),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomSvgPicture(
              image: icon,
              height: size,
              width: size,
              fit: BoxFit.cover,
              color: textColor,
            ),
            horizontalSpace(Dimensions.space5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: regularLarge.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Icon Button Widget
class IconButtonWidget extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const IconButtonWidget({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.bounceInOut),
            ),
            child: child,
          );
        },
        child: Container(
          key: ValueKey<String>(text),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.cardRadius2),
          ),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [color, color.withOpacity(0.5)],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: CustomSvgPicture(
                  image: iconPath,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
              ),
              verticalSpace(Dimensions.space5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: regularSmall.copyWith(
                  color: MyColor.getGreyText(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Selection Bar Widget
class SelectionBarWidget extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelected;

  const SelectionBarWidget({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            spreadRadius: 10,
            blurRadius: 5,
            color: MyColor.borderColor.withOpacity(0.25),
          ),
        ],
        color: MyColor.getCardBgColor(),
      ),
      padding: EdgeInsets.all(Dimensions.space15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            items.map((item) {
              return GestureDetector(
                onTap: () => onSelected(item),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.cardRadius2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item,
                          textAlign: TextAlign.center,
                          style: regularDefault.copyWith(
                            color:
                                selectedItem == item
                                    ? MyColor.getPrimaryColor()
                                    : MyColor.getGreyText(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        verticalSpace(Dimensions.space5),
                        Container(
                          width: 20,
                          height: 2,
                          decoration: BoxDecoration(
                            color:
                                selectedItem == item
                                    ? MyColor.getPrimaryColor()
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// Main Screen Widget
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
    return const ProjectListPage();
  }
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
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
                          vertical: Dimensions.space15,
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
                                  onPressed: () {},
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
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.space15,
                            horizontal: Dimensions.space15,
                          ),
                          width: Get.width,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                // Upper Selection bar
                Container(
                  decoration: BoxDecoration(
                    color: MyColor.getCardBgColor(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space20,
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
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath: "assets/images/interface/list.svg",
                          text: "Introduction",
                          color: MyColor.getPrimaryColor(),
                          onTap: () {},
                        ),
                        IconButtonWidget(
                          iconPath:
                              "assets/images/interface/location-point.svg",
                          text: "Location",
                          color: Color(0xffe87a65),
                          onTap: () {},
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
                          iconPath:
                              "assets/images/interface/initial-view.svg",
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

