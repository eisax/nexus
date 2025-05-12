
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/overview/customAppBarWidget.dart';
import 'package:nexus/ui/screens/overview/overview_screen.dart';
import 'package:nexus/ui/screens/overview/widgets/bottomControlsWidget.dart';
import 'package:nexus/ui/screens/overview/widgets/floorAndHelpSectionWidget.dart';

class OverViewScreenWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const OverViewScreenWidget({super.key, required this.onCheckTip});

  @override
  State<OverViewScreenWidget> createState() => _OverViewScreenWidgetState();
}

class _OverViewScreenWidgetState extends State<OverViewScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: InkWell(
        child: Stack(
          children: [
            SafeArea(
              child: Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        CustomAppBar(onCheckTip: widget.onCheckTip),
                        const SizedBox(height: 24),
                        FloorAndHelpSection(onCheckTip: widget.onCheckTip),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BottomControls(onCheckTip: widget.onCheckTip),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
