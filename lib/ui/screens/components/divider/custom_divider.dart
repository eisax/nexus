import 'package:flutter/material.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class CustomDivider extends StatelessWidget {

  final double space;
  final Color color;
  final double? height;

  const CustomDivider({
    super.key,
    this.space = Dimensions.space20,
    this.color = MyColor.colorBlack, this.height
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: space),
        Divider(color: color, height: height ?? 0.5, thickness: height ?? 0.5),
        SizedBox(height: space),
      ],
    );
  }
}
