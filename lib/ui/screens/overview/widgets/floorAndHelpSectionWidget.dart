import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/overview/customAppBarWidget.dart';
import 'package:nexus/ui/screens/overview/overview_screen.dart';


class FloorAndHelpSection extends StatelessWidget {
  final void Function() onCheckTip;

  const FloorAndHelpSection({super.key, required this.onCheckTip});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
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
              "Floor",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              "assets/images/help-question.svg",
              fit: BoxFit.cover,
              color: const Color(0xff2d71ff),
              height: 16,
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: onCheckTip,
              child: Container(
                decoration: const BoxDecoration(),
                child: const Text(
                  "Help",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Color(0xff2d71ff),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
