import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/scan/scan_screen.dart';
import 'package:nexus/ui/screens/scan/widget/frameAnimationWidget.dart';

class ScanScreenWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const ScanScreenWidget({super.key, required this.onCheckTip});

  @override
  State<ScanScreenWidget> createState() => _ScanScreenWidgetState();
}

class _ScanScreenWidgetState extends State<ScanScreenWidget> {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: ()=>Get.back(),
                          child: Container(
                            height: 30,
                            width: 30,

                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              "assets/images/close_simple.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.from(
                                  alpha: 0.545,
                                  red: 1,
                                  green: 1,
                                  blue: 1,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                 onTap: widget.onCheckTip,
                                
                                child: Container(
                                  color: const Color.from(
                                    alpha: 0.55,
                                    red: 0,
                                    green: 0,
                                    blue: 0,
                                  ),
                                  child: FrameAnimation(width: 75, height: 100),
                                ),
                              ),
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
              top: Get.height / 2.5,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Image.asset(
                      "assets/images/shoot_icon.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: ()=>Get.toNamed(RouteHelper.overview),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.from(
                          alpha: 0.75,
                          red: 0,
                          green: 0,
                          blue: 0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Aim the dot",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ],
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
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/pan_icon_recover.png",
                              ),
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "0/100",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Color(0xffffffff),
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
