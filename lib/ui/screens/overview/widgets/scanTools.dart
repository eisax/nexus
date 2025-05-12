import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/data/controller/theme_controller.dart';
import 'package:nexus/ui/screens/components/divider/custom_divider.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/screens/components/menu_row_widget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';

class ScanToolsModalWidget extends StatefulWidget {
  const ScanToolsModalWidget({super.key});

  @override
  State<ScanToolsModalWidget> createState() => _ScanToolsModalWidgetState();
}

class _ScanToolsModalWidgetState extends State<ScanToolsModalWidget> {
  bool activateProject = false;

  List<String> withdrawMethodList = [
    "Limited spatial vision",
    "Complete spatial vision",
  ];
  String? selectedWithdrawMethod = "Limited spatial vision";

  setWithdrawMethod(String? method) {
    selectedWithdrawMethod = method;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return Stack(
          children: [
            //Main code
            Container(
              margin: const EdgeInsetsDirectional.only(top: Dimensions.space20),
              decoration: BoxDecoration(
                color: MyColor.getScreenBgColor(),
                borderRadius: const BorderRadiusDirectional.only(
                  topEnd: Radius.circular(25),
                  topStart: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: Dimensions.space15,
                      vertical: Dimensions.space15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Scan Tools",
                                style: boldOverLarge.copyWith(
                                  color: MyColor.getHeadingTextColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomDivider(
                    height: 1,
                    space: Dimensions.space5,
                    color: MyColor.borderColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.space10),
                        decoration: BoxDecoration(
                          color: MyColor.getScreenBgSecondaryColor(),
                          borderRadius: BorderRadius.circular(
                            Dimensions.space12,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MyColor.getCardBgColor(),
                              blurRadius: 10,
                              offset: Offset(5, 5),
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            MenuRowWidget(
                              image: MyIcons.floor,
                              imageSize: 24,
                              label: "Floor Adjustment",
                              subLabel: "Aligning floors by hand",
                              onPressed: () {
                                //  Get.toNamed(RouteHelper.withdrawScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //bottom sheet closer
            Positioned(
              top: 0,
              left: 20,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(),
                child: Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: MyColor.secondaryColor100,
                      shape: const CircleBorder(),
                    ),
                    child: FittedBox(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.back();
                        },
                        icon: MyLocalImageWidget(
                          imagePath: MyIcons.doubleArrowDown,
                          imageOverlayColor: MyColor.secondaryColor900,
                          width: Dimensions.space25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
