import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/components/buttons/rounded_button.dart';
import 'package:nexus/ui/screens/components/menu_row_widget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_images.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();

  static Widget routeInstance() {
    return const AddDeviceScreen();
  }
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getAppBarColor(),
      appBar: AppBar(
        elevation: 5,
        automaticallyImplyLeading: false,
        backgroundColor: MyColor.getCardBgColor(),
        surfaceTintColor: Colors.transparent,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: SvgPicture.asset(
                "assets/images/left_arrow_simple.svg",
                width: 24,
                height: 24,
                fit: BoxFit.fitHeight,
                color: MyColor.getContentTextColor(),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Device Management",
                    style: boldOverLarge.copyWith(
                      color: MyColor.getHeadingTextColor(),
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 24),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.space15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              isLoading: false,
              text: "Add Device",
              press: () {
             Get.toNamed(RouteHelper.selectdevice);
              },
              cornerRadius: Dimensions.space15,
              color: MyColor.getPrimaryColor(),
              textStyle: boldExtraLarge.copyWith(
                color: MyColor.getCardBgColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
