import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/my_color.dart';

class RoundedButton extends StatelessWidget {
  final bool isColorChange;
  final String text;
  final VoidCallback press;
  final Color disableColor;
  final Color color;
  final Color? textColor;
  final double width;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final bool isOutlined;
  final Widget? child;
  final TextStyle? textStyle;
  final bool isLoading;
  final Color borderColor;
  final Color? loadingIndicatorColor;
  final bool isDisabled;

  const RoundedButton({
    super.key,
    this.isColorChange = false,
    this.width = 1,
    this.child,
    this.cornerRadius = 8,
    required this.text,
    required this.press,
    this.isOutlined = false,
    this.horizontalPadding = 30,
    this.verticalPadding = 15,
    this.color = MyColor.primaryButtonColor,
    this.disableColor = MyColor.secondaryColor500,
    this.textColor = MyColor.colorWhite,
    this.textStyle,
    this.isLoading = false,
    this.borderColor = MyColor.primaryColorDark,
    this.loadingIndicatorColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild =
        child ??
        Text(
          text.tr,
          style:
              textStyle ??
              regularLarge.copyWith(
                color:
                    isColorChange
                        ? textColor
                        : MyColor.getPrimaryButtonTextColor(),
                fontSize: 14,
              ),
        );

    return SizedBox(
      width: double.infinity,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed:
                    isDisabled
                        ? null
                        : isLoading == true
                        ? null
                        : press,
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  side: BorderSide(
                    color: borderColor,
                    width: 2,
                  ), // Border color for outlined button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cornerRadius),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        )
                        : buttonChild,
              )
              : ElevatedButton(
                onPressed:
                    isDisabled
                        ? null
                        : isLoading == true
                        ? () {}
                        : press,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  disabledBackgroundColor: disableColor,
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cornerRadius),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              loadingIndicatorColor ??
                                  MyColor.getPrimaryButtonTextColor(),
                            ),
                          ),
                        )
                        : buttonChild,
              ),
    );
  }
}
