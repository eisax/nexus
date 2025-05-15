import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/textfield/customTextfieldWidget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/util.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();

  static Widget routeInstance() {
    return const PickLocationScreen();
  }
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getCardBgColor(),
      appBar: AppBar(
        elevation: 0,
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
                "assets/images/close_simple.svg",
                colorFilter: ColorFilter.mode(
                  MyColor.getHeadingTextColor(),
                  BlendMode.srcIn,
                ),
                height: 22,
                width: 22,
                fit: BoxFit.contain,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Name",
                    style: boldDefault.copyWith(
                      color: MyColor.getHeadingTextColor(),
                    ),
                  ),
                ],
              ),
            ),

            SvgPicture.asset(
              "assets/icons/right_simple.svg",
              colorFilter: ColorFilter.mode(
                MyColor.getPrimaryColor(),
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
              fit: BoxFit.fill,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.space15,right:  Dimensions.space15,bottom:  Dimensions.space15),
            child: CustomTextField(
              hintText: 'Enter address to search the location',
              animatedLabel: false,
              needOutlineBorder: true,
              isShowSuffixIcon: true,
              labelText: "",
              textInputType: MyUtils.getInputTextFieldType("text"),
              onChanged: (value) {},
              isIcon: true,
            ),
          ),
          Expanded(
            child: Container(
              width: Get.width,
              color: MyColor.getAppBarColor(),
               padding: EdgeInsets.all(Dimensions.space15),
              child: Column(children: [
                 
                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
