import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/divider/custom_divider.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';
import 'package:nexus/utils/my_images.dart';
import 'package:nexus/utils/my_strings.dart';

class DeleteAccountBottomsheetBody extends StatefulWidget {
  const DeleteAccountBottomsheetBody({super.key});

  @override
  State<DeleteAccountBottomsheetBody> createState() =>
      _DeleteAccountBottomsheetBodyState();
}

class _DeleteAccountBottomsheetBodyState
    extends State<DeleteAccountBottomsheetBody> {
  @override
  Widget build(BuildContext context) {
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
            boxShadow: [
              BoxShadow(
                color: MyColor.getPrimaryColor().withOpacity(0.2),
                offset: const Offset(0, -4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
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
                            text: "Delele Account",
                            style: regularLarge.copyWith(
                              color: MyColor.redCancelTextColor,
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
                color: MyColor.getBorderColor(),
              ),
              const SizedBox(height: Dimensions.space25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Image.asset(
                      MyImages.userdeleteImage,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: Dimensions.space25),
                    Text(
                      "Delete your account",
                      style: semiBoldDefault.copyWith(
                        color: MyColor.getLabelTextColor(),
                        fontSize: Dimensions.fontLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.space25),
                    Text(
                      "Delete -----what what",
                      style: regularDefault.copyWith(
                        color: MyColor.getSecondaryTextColor(),
                        fontSize: Dimensions.fontLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.space40),
                    GestureDetector(
                      onTap: () {
                        // controller.removeAccount();
                      },
                      child: Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space15 + 2,
                        ),
                        decoration: BoxDecoration(
                          color: MyColor.colorRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Delete Account",
                            style: semiBoldDefault.copyWith(
                              color: MyColor.colorWhite,
                              fontSize: Dimensions.fontLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space20),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: MyColor.getPrimaryColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: semiBoldDefault.copyWith(
                              color: MyColor.colorWhite,
                              fontSize: Dimensions.fontLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        ),
      ],
    );

    // return Column(
    //   children: [
    //     const SizedBox(height: Dimensions.space25),
    //     Image.asset(
    //       MyImages.userdeleteImage,
    //       width: 120,
    //       height: 120,
    //       fit: BoxFit.cover,
    //     ),
    //     const SizedBox(height: Dimensions.space25),
    //     Text(
    //       MyStrings.deleteYourAccount.tr,
    //       style: semiBoldDefault.copyWith(color: MyColor.getLabelTextColor(), fontSize: Dimensions.fontLarge),
    //       textAlign: TextAlign.center,
    //     ),
    //     const SizedBox(height: Dimensions.space25),
    //     Text(
    //       MyStrings.deleteBottomSheetSubtitle.tr,
    //       style: regularDefault.copyWith(color: MyColor.colorGrey.withOpacity(0.8), fontSize: Dimensions.fontLarge),
    //       textAlign: TextAlign.center,
    //     ),
    //     const SizedBox(height: Dimensions.space40),
    //     GestureDetector(
    //       onTap: () {
    //         controller.removeAccount();
    //       },
    //       child: Container(
    //         width: context.width,
    //         padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space15 + 2),
    //         decoration: BoxDecoration(
    //           color: MyColor.colorRed,
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //         child: Center(
    //           child: controller.removeLoading
    //               ? const SizedBox(
    //                   width: Dimensions.fontExtraLarge + 3,
    //                   height: Dimensions.fontExtraLarge + 3,
    //                   child: CircularProgressIndicator(color: MyColor.colorWhite, strokeWidth: 2),
    //                 )
    //               : Text(
    //                   MyStrings.deleteAccount.tr,
    //                   style: semiBoldDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge),
    //                 ),
    //         ),
    //       ),
    //     ),
    //     const SizedBox(height: Dimensions.space20),
    //     GestureDetector(
    //       onTap: () {
    //         Get.back();
    //       },
    //       child: Container(
    //         width: context.width,
    //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    //         decoration: BoxDecoration(
    //           color: MyColor.colorGrey.withOpacity(0.15),
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //         child: Center(
    //           child: Text(
    //             MyStrings.cancel.tr,
    //             style: semiBoldDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontLarge),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
