import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/data/controller/theme_controller.dart';
import 'package:nexus/ui/screens/components/buttons/rounded_button.dart';
import 'package:nexus/ui/screens/components/divider/custom_divider.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/screens/components/text/header_text.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';
import 'package:nexus/utils/my_images.dart';
import 'package:nexus/utils/my_strings.dart';
import 'widgets/account_user_card.dart';
import 'widgets/menu_row_widget.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  State<ProfileAndSettingsScreen> createState() =>
      _ProfileAndSettingsScreenState();

  static Widget routeInstance() {
    return const ProfileAndSettingsScreen();
  }
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/close_simple.svg",
                              fit: BoxFit.cover,
                              color: MyColor.getGreyText(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
                //header
                Container(
                  decoration: BoxDecoration(
                    color: MyColor.getScreenBgSecondaryColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space12),
                    // boxShadow: MyUtils.getCardShadow(),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: Dimensions.space15,
                      end: Dimensions.space15,
                      top: Dimensions.space15,
                      bottom: Dimensions.space15,
                    ),
                    child: AccountUserCard(
                      isLoading: false,
                      // onTap: () => Get.toNamed(RouteHelper.profileScreen),
                      fullName: "Kudah Ndhlovu",
                      username: "eisax",
                      subtitle: "+263774259097",
                      rating: 'hide',
                      imgWidget: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MyColor.borderColor,
                            width: 0.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        height: Dimensions.space50 + 35,
                        width: Dimensions.space50 + 35,
                        // child: ClipOval(
                        //   child: (true)
                        //       ? const MyLocalImageWidget(
                        //           imagePath: MyImages.noProfileImage,
                        //           boxFit: BoxFit.cover,
                        //           height: Dimensions.space50 + 60,
                        //           width: Dimensions.space50 + 60,
                        //         )
                        // ),
                      ),
                      imgHeight: 40,
                      imgwidth: 40,
                    ),
                  ),
                ),
                verticalSpace(Dimensions.space20),
          
                const SizedBox(height: Dimensions.space10),
                Container(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  decoration: BoxDecoration(
                    color: MyColor.getScreenBgSecondaryColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space12),
                    // boxShadow: MyUtils.getCardShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MenuRowWidget(
                        label: "General",
                        onPressed: () {
                          //  Get.toNamed(RouteHelper.withdrawScreen);
                        },
                      ),
                      CustomDivider(
                        space: Dimensions.space15,
                        color: MyColor.getBorderColor(),
                      ),
                      MenuRowWidget(
                        label: "Device management",
                        onPressed: () {
                          //  Get.toNamed(RouteHelper.depositScreen);
                        },
                      ),
                      CustomDivider(
                        space: Dimensions.space15,
                        color: MyColor.getBorderColor(),
                      ),
                      MenuRowWidget(
                        label: "Help Center",
                        onPressed: () {
                          // Get.toNamed(RouteHelper.walletHistoryScreen);
                        },
                      ),
                      CustomDivider(
                        space: Dimensions.space15,
                        color: MyColor.getBorderColor(),
                      ),
                      MenuRowWidget(
                        label: "Storage",
                        onPressed: () {
                          // Get.toNamed(RouteHelper.walletHistoryScreen);
                        },
                      ),
                      CustomDivider(
                        space: Dimensions.space15,
                        color: MyColor.getBorderColor(),
                      ),
                      MenuRowWidget(
                        label: "About us",
                        onPressed: () {
                          // Get.toNamed(RouteHelper.walletHistoryScreen);
                        },
                      ),
                      CustomDivider(
                        space: Dimensions.space15,
                        color: MyColor.getBorderColor(),
                      ),
                      MenuRowWidget(
                        label: "Contact us",
                        onPressed: () {
                          // Get.toNamed(RouteHelper.walletHistoryScreen);
                        },
                      ),
                      CustomDivider(
                        space: Dimensions.space15,
                        color: MyColor.getBorderColor(),
                      ),
                      MenuRowWidget(
                        label: "Feedback and Suggestions",
                        onPressed: () {
                          // Get.toNamed(RouteHelper.walletHistoryScreen);
                        },
                      ),
                      verticalSpace(Dimensions.space10),
                    ],
                  ),
                ),
          
                verticalSpace(Dimensions.space20),
                if (true) ...[
                  RoundedButton(
                    isLoading: false,
                    color: MyColor.colorRed,
                    text: "Logout",
                    press: () {},
                  ),
                  verticalSpace(Dimensions.space75),
                ],
              ],
            ),
          ),
        );
        ;
      },
    );
  }
}
