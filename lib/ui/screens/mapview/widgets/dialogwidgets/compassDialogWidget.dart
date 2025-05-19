import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/data/controller/theme_controller.dart';
import 'package:nexus/ui/screens/components/textfield/customTextfieldWidget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/util.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class CompassDialogWidget extends StatefulWidget {
  const CompassDialogWidget({super.key});

  @override
  State<CompassDialogWidget> createState() => _CompassDialogWidgetState();
}

class _CompassDialogWidgetState extends State<CompassDialogWidget> {
  bool activateProject = false;
  double _targetDegree = 0.0;
  bool _isAligned = false;

  void _onTargetChanged(double val) {
    setState(() {
      _targetDegree = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return Stack(
          children: [
            //Main code
            Container(
              margin: const EdgeInsetsDirectional.only(top: Dimensions.space20),
              decoration: BoxDecoration(
                color: MyColor.getScreenBgColor(),
                borderRadius: const BorderRadiusDirectional.only(
                  topEnd: Radius.circular(7),
                  topStart: Radius.circular(7),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: Dimensions.space15,
                      vertical: Dimensions.space15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: SvgPicture.asset(
                            "assets/images/close_simple.svg",
                            colorFilter: ColorFilter.mode(
                              MyColor.getHeadingTextColor(),
                              BlendMode.srcIn,
                            ),
                            height: 22,
                            width: 22,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Compass",
                                style: boldDefault.copyWith(
                                  color: MyColor.getHeadingTextColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/right_simple.svg",
                          colorFilter: ColorFilter.mode(
                            MyColor.getPrimaryColor(),
                            BlendMode.srcIn,
                          ),
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    child: SizedBox(
                     
                      child: Column(
                        children: [
                          CompassRulerWidget(
                            targetDegree: _targetDegree,
                            onTargetChanged: _onTargetChanged,
                            onAligned: (aligned) {
                              setState(() {
                                _isAligned = aligned;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _targetDegree = 0.0;
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset to North'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          if (_isAligned)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 6),
                                  Text(
                                    'Aligned!',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CompassRulerWidget extends StatefulWidget {
  final double targetDegree;
  final ValueChanged<double> onTargetChanged;
  final ValueChanged<bool>? onAligned;
  const CompassRulerWidget({Key? key, required this.targetDegree, required this.onTargetChanged, this.onAligned}) : super(key: key);

  @override
  State<CompassRulerWidget> createState() => _CompassRulerWidgetState();
}

class _CompassRulerWidgetState extends State<CompassRulerWidget> {
  late ScrollController _scrollController;
  double _currentDegree = 0.0;
  double _targetDegree = 0.0;
  static const int totalDegrees = 360;
  static const double tickSpacing = 16.0;
  static const double rulerWidth = totalDegrees * tickSpacing;
  static const double alignThreshold = 5.0; // degrees

  @override
  void initState() {
    super.initState();
    _targetDegree = widget.targetDegree;
    _scrollController = ScrollController(
      initialScrollOffset: _targetDegree * tickSpacing,
    );
    FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        setState(() {
          _currentDegree = event.heading!;
        });
        _checkAlignment();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CompassRulerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDegree != widget.targetDegree) {
      _targetDegree = widget.targetDegree;
      _scrollController.jumpTo(_targetDegree * tickSpacing);
      _checkAlignment();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getDirectionLabel(double degree) {
    if (degree >= 337.5 || degree < 22.5) return "North";
    if (degree >= 22.5 && degree < 67.5) return "NE";
    if (degree >= 67.5 && degree < 112.5) return "East";
    if (degree >= 112.5 && degree < 157.5) return "SE";
    if (degree >= 157.5 && degree < 202.5) return "South";
    if (degree >= 202.5 && degree < 247.5) return "SW";
    if (degree >= 247.5 && degree < 292.5) return "West";
    if (degree >= 292.5 && degree < 337.5) return "NW";
    return "";
  }

  void _onTapTick(int index) {
    // Snap to nearest 10°
    final snapped = (index / 10).round() * 10;
    setState(() {
      _targetDegree = snapped.toDouble();
    });
    widget.onTargetChanged(_targetDegree);
    _scrollController.animateTo(_targetDegree * tickSpacing, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    HapticFeedback.selectionClick();
    _checkAlignment();
  }

  void _checkAlignment() {
    final diff = ((_currentDegree - _targetDegree + 360) % 360).abs();
    final aligned = diff <= alignThreshold || (360 - diff) <= alignThreshold;
    if (widget.onAligned != null) {
      widget.onAligned!(aligned);
    }
  }

  @override
  Widget build(BuildContext context) {
    final diff = ((_currentDegree - _targetDegree + 360) % 360).abs();
    return Column(
      children: [
        Text(
          _getDirectionLabel(_currentDegree),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: totalDegrees,
                itemBuilder: (context, index) {
                  final isMajor = index % 10 == 0;
                  final isCurrent = (index - _currentDegree).abs() < 0.5;
                  final isTarget = (index - _targetDegree).abs() < 0.5;
                  return GestureDetector(
                    onTap: () => _onTapTick(index),
                    child: Container(
                      width: tickSpacing,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: isMajor ? 3 : 1,
                            height: isMajor ? 30 : 18,
                            color: isTarget
                                ? Colors.green
                                : isCurrent
                                    ? Colors.blue
                                    : isMajor
                                        ? Colors.black
                                        : Colors.black54,
                          ),
                          if (isMajor)
                            Text(
                              index.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: isTarget
                                    ? Colors.green
                                    : isCurrent
                                        ? Colors.blue
                                        : Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Center indicator
            Positioned(
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.withOpacity(0.5), Colors.blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${_currentDegree.toStringAsFixed(1)}°',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          'Target: ${_targetDegree.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
        ),
        Text(
          'Difference: ${diff.toStringAsFixed(1)}°',
          style: const TextStyle(fontSize: 14, color: Colors.deepOrange, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
