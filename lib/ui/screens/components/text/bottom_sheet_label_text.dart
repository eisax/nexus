import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/my_color.dart';

class BottomSheetLabelText extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;

  const BottomSheetLabelText({
    super.key,
    required this.text,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: textAlign,
      style: regularSmall.copyWith(color: MyColor.contentTextColor, fontWeight: FontWeight.w500)
    );
  }
}
