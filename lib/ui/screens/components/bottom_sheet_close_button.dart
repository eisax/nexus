import 'package:flutter/material.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class BottomSheetCloseButton extends StatelessWidget {
  const BottomSheetCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 30, width: 30,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.space5),
        decoration:  BoxDecoration(color: MyColor.secondaryColor900, shape: BoxShape.circle),
        child:  Icon(Icons.clear, color: MyColor.secondaryColor600, size: 15),
      ),
    );
  }
}
