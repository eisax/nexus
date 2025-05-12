import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';
import 'package:nexus/utils/my_strings.dart';


class LanguageDialogBody extends StatefulWidget {
  final  langList;
  final bool fromSplashScreen;
  final String selectedlanguageCode;

  const LanguageDialogBody({super.key, required this.langList, this.fromSplashScreen = false, required this.selectedlanguageCode});

  @override
  State<LanguageDialogBody> createState() => _LanguageDialogBodyState();
}

class _LanguageDialogBodyState extends State<LanguageDialogBody> {
  int pressIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Stack(
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
                boxShadow: [
                  BoxShadow(
                    color: MyColor.getPrimaryColor().withOpacity(0.2),
                    offset: const Offset(0, -4),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space15),
              child: Column(
                children: [
                  verticalSpace(Dimensions.space30),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          "Select Language",
                          style: regularDefault.copyWith(color: MyColor.getPrimaryTextColor(), fontSize: Dimensions.fontLarge),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.space15,
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.langList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                             
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                                decoration: BoxDecoration(color: MyColor.getScreenBgSecondaryColor(), borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (widget.langList[index].languageName).tr,
                                      style: regularDefault.copyWith(color: MyColor.getPrimaryTextColor()),
                                    ),
                                    if (pressIndex == index) ...[
                                      const Center(
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: MyColor.primaryColor,
                                              strokeWidth: 0.8,
                                            )),
                                      )
                                    ] else ...[
                                      if (widget.selectedlanguageCode == widget.langList[index].languageCode) ...[
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: MyColor.getPrimaryColor(),
                                        )
                                      ]
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                      color: MyColor.getTabBarTabBackgroundColor(),
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
                          imageOverlayColor: MyColor.getPrimaryTextColor(),
                          width: Dimensions.space25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
