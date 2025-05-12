import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/scan/widget/frameAnimationWidget.dart' show FrameAnimation;



class PhoneScanTipWidget extends StatefulWidget {
  final void Function() onReady;
  final double scale;
  const PhoneScanTipWidget({super.key, required this.onReady, this.scale = 1});

  @override
  State<PhoneScanTipWidget> createState() => _PhoneScanTipWidgetState();
}

class _PhoneScanTipWidgetState extends State<PhoneScanTipWidget> {
  bool _doNotRemindMe = false;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: InkWell(
          child: Stack(
            children: [
              Positioned.fill(
                top: Get.height / 3 - 72,
                child: Column(
                  children: [
                    FrameAnimation(
                      width: Get.width * 0.75,
                      height: Get.width * 0.75,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Fix phone position, to align the phone. Use a gimble for better results",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Keep your phone steady when positioning to improve 3D tour image quality.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: widget.onReady,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "Ready to go",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.75,
                              child: Checkbox(
                                checkColor: Colors.white,
                                visualDensity: const VisualDensity(
                                  horizontal: -4.0,
                                  vertical: -4.0,
                                ),
                                value: _doNotRemindMe,
                                onChanged: (value) {
                                  setState(() {
                                    _doNotRemindMe = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 0),
                            const Text(
                              "Do not remind again",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
