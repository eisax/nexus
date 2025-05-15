import 'package:flutter/material.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class CustomBottomSheet {
  final Widget child;
  bool isNeedMargin;
  final VoidCallback? voidCallback;
  final Color bgColor;
  final double borderRadius;

  CustomBottomSheet({
    required this.child,
    this.borderRadius = 15,
    this.isNeedMargin = false,
    this.voidCallback,
    this.bgColor = MyColor.colorWhite,
  });

  void customBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: MyColor.transparentColor,
      context: context,
      builder:
          (BuildContext context) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 50),
              curve: Curves.decelerate,
              child: Container(
                margin:
                    isNeedMargin
                        ? const EdgeInsets.only(left: 15, right: 15, bottom: 15)
                        : EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2,
                        ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.space15,
                  vertical: Dimensions.space12,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius:
                      isNeedMargin
                          ? BorderRadius.circular(borderRadius)
                          : BorderRadius.vertical(
                            top: Radius.circular(borderRadius),
                          ),
                ),
                child: child,
              ),
            ),
          ),
    ).then((value) => voidCallback);
  }
}
