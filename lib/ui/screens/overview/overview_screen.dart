import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus/ui/screens/components/bottom-sheet/custom_bottom_sheet_plus.dart';
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
    return const ProjectListPage();
  }
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6fbfd),
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
                        Row(
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

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/left_arrow_simple.svg",
                                        fit: BoxFit.cover,
                                        color: Color(0xFF5b6368),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Image.asset(
                                          'assets/images/icon_phone2.png',
                                          width: 20,
                                          height: 25,
                                          color: Color(0xFF5b6368),
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
                                    onTap: widget.onCheckTip,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: Text(
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
                                    onTap: widget.onCheckTip,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff2d71ff),
                                        borderRadius: BorderRadius.circular(35),
                                        border: Border.all(
                                          color: Color(0xFFe7ebff),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
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
                        ),

                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: widget.onCheckTip,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff2d71ff),
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    color: Color(0xFFe7ebff),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
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
                                  color: Color(0xff2d71ff),
                                  height: 16,
                                ),
                                SizedBox(width: 3),
                                GestureDetector(
                                  onTap: widget.onCheckTip,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(
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
                        ),
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
                      GestureDetector(
                        onTap: widget.onCheckTip,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: Color(0xFFe7ebff),
                              width: 1,
                            ),
                          ),
                          child: Text(
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
                            onTap:
                                () => CustomBottomSheetPlus(
                                  child: ScanSettingsModalWidget(),
                                  isNeedPadding: false,
                                  bgColor: MyColor.transparentColor,
                                ).show(context),
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFe7ebff),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/images/settings.svg",
                                color: Color(0xFF5b6368),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onCheckTip,
                            child: Container(
                              height: 60,
                              width: 60,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
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
                            onTap:
                                () => CustomBottomSheetPlus(
                                  child: ScanToolsModalWidget(),
                                  isNeedPadding: false,
                                  bgColor: MyColor.transparentColor,
                                ).show(context),
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFe7ebff),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/images/grid.svg",
                                color: Color(0xFF5b6368),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Sanned points: 0/100",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Color(0xFF5b6368),
                        ),
                      ),
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
