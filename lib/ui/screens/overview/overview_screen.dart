import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:nexus/ui/screens/overview/widgets/overViewScreenWidget.dart';
import 'package:nexus/ui/screens/overview/widgets/scanSettings.dart';
import 'package:nexus/ui/screens/overview/widgets/scanTools.dart';
import 'package:nexus/utils/my_color.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();

  static Widget routeInstance() {
    return const OverViewScreen();
  }
}

class _OverViewScreenState extends State<OverViewScreen> {
  @override
  Widget build(BuildContext context) {
    return const OverViewWidget();
  }
}

class OverViewWidget extends StatefulWidget {
  const OverViewWidget({super.key});

  @override
  _OverViewWidgetState createState() => _OverViewWidgetState();
}

class _OverViewWidgetState extends State<OverViewWidget>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6fbfd),
      body: Stack(
        children: [
          Positioned(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: OverViewScreenWidget(
                key: const ValueKey('readyToGo'),
                onCheckTip: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}



