import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:nexus/ui/screens/overview/widgets/overViewScreenWidget.dart';
import 'package:nexus/ui/screens/overview/widgets/scanSettings.dart';
import 'package:nexus/ui/screens/overview/widgets/scanTools.dart';
import 'package:nexus/utils/my_color.dart';

class BottomControls extends StatelessWidget {
  final void Function() onCheckTip;

  const BottomControls({super.key, required this.onCheckTip});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onCheckTip,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: const Color(0xFFe7ebff),
                width: 1,
              ),
            ),
            child: const Text(
              "Preview",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Color(0xff121212),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => CustomBottomSheetPlus(
                child: const ScanSettingsModalWidget(),
                isNeedPadding: false,
                bgColor: MyColor.transparentColor,
              ).show(context),
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFe7ebff),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/images/settings.svg",
                  color: const Color(0xFF5b6368),
                ),
              ),
            ),
            GestureDetector(
              onTap: onCheckTip,
              child: Container(
                height: 60,
                width: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/startimage17.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/images/add_simple.svg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => CustomBottomSheetPlus(
                child: const ScanToolsModalWidget(),
                isNeedPadding: false,
                bgColor: MyColor.transparentColor,
              ).show(context),
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFe7ebff),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/images/grid.svg",
                  color: const Color(0xFF5b6368),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Scanned points: 0/100",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Color(0xFF5b6368),
          ),
        ),
      ],
    );
  }
}
