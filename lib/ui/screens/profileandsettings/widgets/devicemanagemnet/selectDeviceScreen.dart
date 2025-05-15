import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';
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

class SelectDeviceScreen extends StatefulWidget {
  const SelectDeviceScreen({super.key});

  @override
  State<SelectDeviceScreen> createState() => _SelectDeviceScreenState();

  static Widget routeInstance() {
    return const SelectDeviceScreen();
  }
}

class _SelectDeviceScreenState extends State<SelectDeviceScreen> {
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
          body: Container(
            padding: EdgeInsets.all(Dimensions.space20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background/bg_app_3.png"),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.space10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(shape: BoxShape.circle),
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
                verticalSpace(Dimensions.space20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Select equipment",
                        style: boldExtraLarge.copyWith(
                          color: MyColor.getHeadingTextColor(),
                          fontSize: Dimensions.fontSizeHeaderText,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(Dimensions.space12),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Select the capture device you use",
                        style: boldLarge.copyWith(color: MyColor.getGreyText()),
                      ),
                    ],
                  ),
                ),
                verticalSpace(Dimensions.space12),
                //phone
                CustomSelectDeviceButton(
                  title: "Phone",
                  subtitle: ' "Easy Capture anytime anywhere"',
                  image: "assets/images/devices/ic_device_phone.png",
                  onPressed: () {},
                ),
                verticalSpace(Dimensions.space15),
                //galois
                CustomSelectDeviceButton(
                  title: "Galois",
                  subtitle: "Proffesional 3D laser scanner",
                  image: "assets/images/devices/ic_galois_chromatic.png",
                  onPressed: () {},
                ),
                verticalSpace(Dimensions.space15),
                //camera
                CustomSelectDeviceButton(
                  title: "Camera",
                  subtitle: "Transform 2D to 3D automatically",
                  image: "assets/images/devices/ic_camera_chromatic.png",
                  onPressed: () {},
                ),
                //camera
                CustomSelectDeviceButton(
                  title: "Additional",
                  subtitle: "High quality image by phone",
                  image: "assets/images/devices/ic_poincare_chromatic.png",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomSelectDeviceButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onPressed;

  const CustomSelectDeviceButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(Dimensions.space10),
        decoration: BoxDecoration(
          color: MyColor.getCardBgColor(),
          borderRadius: BorderRadius.circular(Dimensions.space12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                MyLocalImageWidget(imagePath: image, height: 60),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: title,
                            style: boldOverLarge.copyWith(
                              color: MyColor.getHeadingTextColor(),
                              fontSize: Dimensions.fontOverLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: subtitle,
                            style: boldLarge.copyWith(
                              color: MyColor.getContentTextColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            MyLocalImageWidget(
              imagePath: "assets/images/devices/ic_change_device.png",
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
