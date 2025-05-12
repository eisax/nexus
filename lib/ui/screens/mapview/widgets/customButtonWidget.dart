import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;
  final Color textColor;
  final double size;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.space12,
          vertical: Dimensions.space5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: color,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              spreadRadius: 10,
              blurRadius: 5,
              color: MyColor.borderColor.withOpacity(0.25),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomSvgPicture(
              image: icon,
              height: size,
              width: size,
              fit: BoxFit.cover,
              color: textColor,
            ),
            horizontalSpace(Dimensions.space5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: regularLarge.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
