import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/scan/scan_screen.dart';
import 'package:nexus/ui/screens/scan/widget/frameAnimationWidget.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ScanScreenWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const ScanScreenWidget({super.key, required this.onCheckTip});

  @override
  State<ScanScreenWidget> createState() => _ScanScreenWidgetState();
}

class _ScanScreenWidgetState extends State<ScanScreenWidget> {
  double _x = 0.0; // Offset for X
  double _y = 0.0; // Offset for Y
  late StreamSubscription<GyroscopeEvent> _gyroSubscription;

  @override
  void initState() {
    super.initState();
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        // Tune the sensitivity factor to get smoother motion
        double sensitivity = 5.0;

        _x += event.y * sensitivity;
        _y += event.x * sensitivity;

        // Optional: Clamp the movement within screen bounds
        _x = _x.clamp(-150.0, 150.0);
        _y = _y.clamp(-300.0, 300.0);
      });
    });
  }

  @override
  void dispose() {
    _gyroSubscription.cancel();
    super.dispose();
  }

  double _calculateProximity(double panelY) {
    final screenHeight = MediaQuery.of(context).size.height;
    final center = screenHeight / 2;
    final distance = (panelY - center).abs();

    // Normalize: 1.0 = at center, 0.0 = far from center
    final proximity = 1.0 - (distance / center).clamp(0.0, 1.0);
    return proximity;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          Positioned(
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
                              onTap: () => Get.back(),
                              child: Container(
                                height: 30,
                                width: 30,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
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
                                      child: FrameAnimation(
                                        width: 75,
                                        height: 100,
                                      ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Image.asset(
                          "assets/images/shoot_icon.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteHelper.overview),
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

          // Positioned(
          //   left: Get.width / 2 + _x,
          //   top: Get.width / 2 + _y,
          //   child: Container(
          //     width: 120,
          //     height: 120,
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //     child: Image.asset(
          //       "assets/images/shoot_icon.png",
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
          Positioned(
            left: Get.width / 2 + _x,
            top: Get.width / 2 + _y,
            child: Container(
              width: 120,
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ProximityFrameAnimation(
                width: 120,
                height: 120,
                proximity: _calculateProximity(Get.width / 2 + _y),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ProximityFrameAnimation extends StatefulWidget {
  final double width;
  final double height;
  final double proximity;

  const ProximityFrameAnimation({
    super.key,
    required this.width,
    required this.height,
    required this.proximity,
  });

  @override
  _ProximityFrameAnimationState createState() =>
      _ProximityFrameAnimationState();
}

class _ProximityFrameAnimationState extends State<ProximityFrameAnimation> {
  final int startFrame = 0;
  final int endFrame =41;
  final Map<int, AssetImage> _frameImages = {};
  int currentFrame = 0;

  Timer? _timer;
  bool isReversing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = startFrame; i <= endFrame; i++) {
      final asset = AssetImage('assets/images/proximity/image$i.png');
      _frameImages[i] = asset;
      precacheImage(asset, context);
    }
  }

  void _startAnimation({required bool forward}) {
    _timer?.cancel();

    final int totalFrames = endFrame - startFrame + 1;
    const duration = Duration(seconds: 5);
    final frameDuration = duration ~/ totalFrames;

    _timer = Timer.periodic(frameDuration, (timer) {
      setState(() {
        if (forward) {
          if (currentFrame < endFrame) {
            currentFrame++;
          } else {
            timer.cancel();
          }
        } else {
          if (currentFrame > startFrame) {
            currentFrame--;
          } else {
            timer.cancel();
          }
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant ProximityFrameAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proximity > 0.7 && isReversing) {
      isReversing = false;
      _startAnimation(forward: true);
    } else if (widget.proximity < 0.4 && !isReversing) {
      isReversing = true;
      _startAnimation(forward: false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _frameImages[currentFrame];

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: image != null
            ? Image(image: image, gaplessPlayback: true, fit: BoxFit.fill)
            : const SizedBox(),
      ),
    );
  }
}

