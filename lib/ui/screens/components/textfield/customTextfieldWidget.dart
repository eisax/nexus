import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus/ui/screens/components/text/label_text_with_instructions.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class CustomTextField extends StatefulWidget {
  final String? instructions;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color? fillColor;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.instructions,
    this.labelText,
    this.readOnly = false,
    this.fillColor,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.isSearch = false,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.needRequiredSign = false,
    this.maxLines = 1,
    this.animatedLabel = false,
    this.isRequired = false,
    this.inputFormatters,
    this.onTap,
    this.borderRadius = Dimensions.cardRadius1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  OutlineInputBorder getConstantBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(width: 0.8, color: borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder constantBorder = getConstantBorder(
      MyColor.getBorderColor(),
    );

    return widget.needOutlineBorder
        ? widget.animatedLabel
            ? _buildAnimatedLabelField(constantBorder)
            : _buildLabeledField(constantBorder)
        : _buildUnderlinedField();
  }

  Widget _buildAnimatedLabelField(OutlineInputBorder constantBorder) {
    return TextFormField(
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      style: regularDefault.copyWith(color: MyColor.getPrimaryTextColor()),
      cursorColor: MyColor.getPrimaryTextColor(),
      controller: widget.controller,
      autofocus: false,
      textInputAction: widget.inputAction,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? obscureText : false,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: (text) {
        if (widget.nextFocus != null) {
          FocusScope.of(context).requestFocus(widget.nextFocus);
        }
      },
      onChanged: (text) => widget.onChanged!(text),
      onTap: widget.onTap,
      decoration: InputDecoration(
        errorStyle: regularLarge.copyWith(color: MyColor.colorRed),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        labelText: widget.labelText ?? '',
        labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
        fillColor: widget.fillColor ?? MyColor.getTextFieldFillColor(),
        filled: true,
        border: constantBorder,
        enabledBorder: constantBorder,
        focusedBorder: constantBorder,
        errorBorder: constantBorder,
        disabledBorder: constantBorder,
        focusedErrorBorder: constantBorder,
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  Widget _buildLabeledField(OutlineInputBorder constantBorder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          LabelTextInstruction(
            text: widget.labelText!,
            isRequired: widget.isRequired,
            instructions: widget.instructions,
          ),
          const SizedBox(height: Dimensions.textToTextSpace),
        ],
        Stack(
          children: [
            TextFormField(
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              style: regularLarge.copyWith(
                color: MyColor.getPrimaryTextColor(),
              ),
              cursorColor: MyColor.getPrimaryTextColor(),
              controller: widget.controller,
              autofocus: false,
              textInputAction: widget.inputAction,
              enabled: widget.isEnable,
              focusNode: widget.focusNode,
              validator: widget.validator,
              keyboardType: widget.textInputType,
              obscureText: widget.isPassword ? obscureText : false,
              inputFormatters: widget.inputFormatters,
              onFieldSubmitted: (text) {
                if (widget.nextFocus != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocus);
                }
              },
              onChanged:
                  (text) => setState(() {
                    widget.onChanged!(text);
                  }),
              onTap: widget.onTap,
              decoration: InputDecoration(
                errorStyle: regularLarge.copyWith(color: MyColor.colorRed),
                contentPadding: EdgeInsets.only(
                  top: widget.maxLines > 1 ? 15 : 5,
                  left: 15,
                  right: 50, // Give space for the icon
                  bottom: 5,
                ),
                hintText: widget.hintText ?? '',
                hintStyle: regularLarge.copyWith(
                  color: MyColor.getTextFieldHintColor(),
                ),
                fillColor: widget.fillColor ?? MyColor.getTextFieldFillColor(),
                filled: true,
                border: constantBorder,
                enabledBorder: constantBorder,
                focusedBorder: constantBorder,
                errorBorder: constantBorder,
                disabledBorder: constantBorder,
                focusedErrorBorder: constantBorder,
              ),
            ),
            if (widget.controller?.text.isNotEmpty ?? false)
              Positioned(
                right: 10,
                bottom: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.controller?.clear();
                      widget.onChanged?.call('');
                    });
                  },
                  child: Icon(
                    Icons.clear,
                    size: 20,
                    color: MyColor.getTextFieldHintColor(),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnderlinedField() {
    return TextFormField(
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      style: regularDefault.copyWith(color: MyColor.getPrimaryTextColor()),
      cursorColor: MyColor.getTextFieldHintColor(),
      controller: widget.controller,
      autofocus: false,
      textInputAction: widget.inputAction,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? obscureText : false,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: (text) {
        if (widget.nextFocus != null) {
          FocusScope.of(context).requestFocus(widget.nextFocus);
        }
      },
      onChanged: (text) => widget.onChanged!(text),
      onTap: widget.onTap,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        labelText: widget.labelText,
        labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
        fillColor: MyColor.transparentColor,
        filled: true,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: MyColor.getTextFieldDisableBorder(),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: MyColor.getTextFieldDisableBorder(),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: MyColor.getTextFieldDisableBorder(),
          ),
        ),
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (!widget.isShowSuffixIcon) return null;

    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: MyColor.getTextFieldHintColor(),
          size: 20,
        ),
        onPressed: _toggle,
      );
    }

    if (widget.isIcon) {
      return IconButton(
        onPressed: widget.onSuffixTap,
        icon: Icon(
          widget.isSearch
              ? Icons.search_outlined
              : widget.isCountryPicker
              ? Icons.arrow_drop_down_outlined
              : Icons.camera_alt_outlined,
          size: 25,
          color: MyColor.getPrimaryColor(),
        ),
      );
    }

    return null;
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
