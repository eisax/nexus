import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/menu_row_widget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_images.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();

  static Widget routeInstance() {
    return const GeneralScreen();
  }
}

class _GeneralScreenState extends State<GeneralScreen> {
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
                    text: "General",
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
          children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.space10),
              decoration: BoxDecoration(
                color: MyColor.getCardBgColor(),
                borderRadius: BorderRadius.circular(Dimensions.space12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Automatically clean up the raw data",
                              style: boldLarge.copyWith(
                                color: MyColor.getHeadingTextColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: FittedBox(
                          child: CupertinoSwitch(
                            value: false,
                            onChanged: (value) {},
                            activeColor: MyColor.greenSuccessColor,
                            trackColor: MyColor.getGreyText(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "When enabled, raw data will be auto-cleaned after VR Tour generation. It won't affect project viewing and modification",
                          style: boldSmall.copyWith(
                            color: MyColor.getContentTextColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
