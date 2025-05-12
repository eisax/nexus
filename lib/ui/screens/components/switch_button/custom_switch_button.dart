import 'package:flutter/material.dart';
import 'package:nexus/utils/my_color.dart';
import 'my_switch_widget.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key,
    required this.value,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return  MySwitchWidget(
      activeIcon: const Icon(Icons.nightlight,size: 18,color: MyColor.primaryColorDark),
      inactiveIcon: const Icon(Icons.sunny,size: 18,color: MyColor.colorGrey),
      width: 55.0,
      height: 30.0,
      valueFontSize: 11.0,
      toggleSize: 20.0,
      value: value,
      borderRadius: 30.0,
      toggleColor: MyColor.colorWhite,
      activeColor: MyColor.primaryColorDark,
      inactiveColor: MyColor.secondaryColor50,
      padding: 4.0,
      showOnOff: false,
      onToggle: onChanged);
  }
}