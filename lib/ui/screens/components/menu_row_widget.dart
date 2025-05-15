import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/text/default_text.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class MenuRowWidget extends StatelessWidget {
  final String? image;
  final double? imageSize;
  final String label;
  final String? subLabel;
  final String? counter;
  final bool counterEnabled;
  final VoidCallback onPressed;
  final Widget? endWidget;
  final Color? iconColor;

  const MenuRowWidget({
    super.key,
    this.image,
    required this.label,
    required this.onPressed,
    this.counter,
    this.counterEnabled = false,
    this.imageSize = 22,
    this.endWidget,
    this.iconColor,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: Dimensions.space5,
          horizontal: Dimensions.space12,
        ),
        color: MyColor.transparentColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null) ...[
                  image!.contains('svg')
                      ? SvgPicture.asset(
                        image!,
                        colorFilter: ColorFilter.mode(
                          iconColor ?? MyColor.getPrimaryTextColor(),
                          BlendMode.srcIn,
                        ),
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.contain,
                      )
                      : Image.asset(
                        image!,
                        color: MyColor.getPrimaryTextColor(),
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.contain,
                      ),
                  const SizedBox(width: Dimensions.space10),
                ],
                SizedBox(
                  width: Get.width*0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultText(
                        text: label.tr,
                        textStyle: boldLarge.copyWith(
                          color: MyColor.getPrimaryTextColor(),
                        ),
                      ),
                      if (subLabel != null)
                        DefaultText(
                          text: subLabel!.tr,
                          textStyle: regularExtraSmall.copyWith(
                            color: MyColor.getGreyText(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (counterEnabled == true && counter != '0')
              Container(
                decoration: BoxDecoration(
                  color: MyColor.colorRed,
                  borderRadius: BorderRadius.circular(Dimensions.space2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.space5,
                ),
                child: Text(
                  "$counter",
                  style: boldDefault.copyWith(color: MyColor.colorWhite),
                ),
              )
            else
              endWidget ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: MyColor.getSecondaryTextColor(),
                    size: Dimensions.space15,
                  ),
          ],
        ),
      ),
    );
  }
}
