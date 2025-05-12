
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

class IconButtonWidget extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const IconButtonWidget({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.bounceInOut),
            ),
            child: child,
          );
        },
        child: Container(
          key: ValueKey<String>(text),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.cardRadius2),
          ),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [color, color.withOpacity(0.5)],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: CustomSvgPicture(
                  image: iconPath,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
              ),
              verticalSpace(Dimensions.space5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: regularSmall.copyWith(
                  color: MyColor.getGreyText(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}