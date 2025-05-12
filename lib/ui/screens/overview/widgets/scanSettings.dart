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

class ScanSettingsModalWidget extends StatefulWidget {
  const ScanSettingsModalWidget({super.key});

  @override
  State<ScanSettingsModalWidget> createState() =>
      _ScanSettingsModalWidgetState();
}

class _ScanSettingsModalWidgetState extends State<ScanSettingsModalWidget> {
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
                                text: "Scan Settings",
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomSvgPicture(
                                image: MyIcons.scan,
                                color: MyColor.getPrimaryTextColor(),
                                height: 20,
                                width: 20,
                              ),
                              horizontalSpace(Dimensions.space7),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Scan mode",
                                      style: regularExtraLarge.copyWith(
                                        color: MyColor.getHeadingTextColor(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(Dimensions.space12),

                          SizedBox(
                            width: Get.width,
                            child: Row(
                              children: List.generate(withdrawMethodList.length, (
                                index,
                              ) {
                                var item = withdrawMethodList[index];
                                return Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setWithdrawMethod(item);
                                      });
                                      //  Get.back();
                                    },
                                    child: Container(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                            vertical: Dimensions.space15,
                                            horizontal: Dimensions.space20,
                                          ),
                                      margin:
                                          const EdgeInsetsDirectional.symmetric(
                                            vertical: Dimensions.space10,
                                            horizontal: Dimensions.space3,
                                          ),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.cardRadius2,
                                        ),
                                        color: MyColor.getPrimaryColor().withOpacity(0.15),
                                        border: Border.all(
                                          color:
                                              selectedWithdrawMethod == item
                                                  ? MyColor.getPrimaryColor()
                                                  : MyColor.getBorderColor(),
                                          width: .5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item,
                                          textAlign: TextAlign.center,
                                          style: boldSmall.copyWith(
                                            color:selectedWithdrawMethod == item?
                                               MyColor.getPrimaryColor():MyColor.getGreyText(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                      
                      
                        ],
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
