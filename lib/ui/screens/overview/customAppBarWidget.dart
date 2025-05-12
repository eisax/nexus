import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class CustomAppBar extends StatelessWidget {
  final void Function() onCheckTip;

  const CustomAppBar({super.key, required this.onCheckTip});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/images/left_arrow_simple.svg",
                    fit: BoxFit.cover,
                    color: const Color(0xFF5b6368),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 20,
                    height: 25,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Image.asset(
                      'assets/images/icon_phone2.png',
                      width: 20,
                      height: 25,
                      color: const Color(0xFF5b6368),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/icon_image_select.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onCheckTip,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(),
                  child: const Text(
                    "Phone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xFF5b6368),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              GestureDetector(
                onTap: onCheckTip,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff2d71ff),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: const Color(0xFFe7ebff),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    "Finish",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
