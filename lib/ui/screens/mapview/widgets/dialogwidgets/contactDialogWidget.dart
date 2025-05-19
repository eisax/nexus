import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/data/controller/theme_controller.dart';
import 'package:nexus/ui/screens/components/divider/custom_divider.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/screens/components/menu_row_widget.dart';
import 'package:nexus/ui/screens/components/textfield/customTextfieldWidget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';
import 'package:nexus/utils/util.dart';

class ContactDialogWidget extends StatefulWidget {
  const ContactDialogWidget({super.key});

  @override
  State<ContactDialogWidget> createState() => _ContactDialogWidgetState();
}

class _ContactDialogWidgetState extends State<ContactDialogWidget> {
  bool activateProject = false;
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
                  topEnd: Radius.circular(7),
                  topStart: Radius.circular(7),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                text: "Contact",
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
                  ),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    child: Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Dimensions.space10),

                            child: Column(
                              children: [
                                CustomTextField(
                                  hintText: 'Nickname (Required)',
                                  animatedLabel: false,
                                  fillColor: Colors.transparent,
                                  needOutlineBorder: true,
                                  labelText: "",
                                  textInputType: MyUtils.getInputTextFieldType(
                                    "text",
                                  ),
                                  onChanged: (value) {},
                                ),
                                CustomTextField(
                                  hintText: 'Introduction (Required)',
                                  animatedLabel: false,
                                  fillColor: Colors.transparent,
                                  needOutlineBorder: true,
                                  labelText: "",
                                  maxLines: 3,
                                  textInputType: MyUtils.getInputTextFieldType(
                                    "text",
                                  ),
                                  onChanged: (value) {},
                                ),
                                CustomTextField(
                                  hintText: 'Contact number',
                                  animatedLabel: false,
                                  fillColor: Colors.transparent,
                                  needOutlineBorder: true,
                                  labelText: "",
                                  textInputType: MyUtils.getInputTextFieldType(
                                    "text",
                                  ),
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
