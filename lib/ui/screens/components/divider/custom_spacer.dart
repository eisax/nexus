import 'package:flutter/widgets.dart';

Widget verticalSpace(double? height) {
  return SizedBox(
    height: height ?? 10,
  );
}

Widget horizontalSpace(double? width) {
  return SizedBox(
    width: width ?? 10,
  );
}
