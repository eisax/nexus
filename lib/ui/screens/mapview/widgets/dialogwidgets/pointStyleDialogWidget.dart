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

class PointStyleDialogWidget extends StatefulWidget {
  const PointStyleDialogWidget({super.key});

  @override
  State<PointStyleDialogWidget> createState() => _PointStyleDialogWidgetState();
}

class _PointStyleDialogWidgetState extends State<PointStyleDialogWidget> {
  int selectedStyle = 3;
  int selectedColor = 0;
  bool isFill = true;
  double size = 0.4;

  final List<IconData> styleIcons = [
    Icons.radio_button_unchecked,
    Icons.circle,
    Icons.directions_walk,
    Icons.directions_run,
  ];
  final List<Color> colors = [
    Colors.white,
    Colors.red[700]!,
    Colors.orange[400]!,
    Colors.yellow[600]!,
    Colors.greenAccent,
    Colors.cyan[400]!,
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close, size: 28),
                      ),
                      const Text(
                        'Point Style',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.check, color: Colors.blue, size: 28),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Style selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Style', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(styleIcons.length, (i) {
                            return GestureDetector(
                              onTap: () => setState(() => selectedStyle = i),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: selectedStyle == i ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
                                  border: Border.all(
                                    color: selectedStyle == i ? Colors.blue : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Icon(styleIcons[i], size: 36, color: Colors.grey[700]),
                                    if (selectedStyle == i)
                                      const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                // Color selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Colour', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(colors.length, (i) {
                            return GestureDetector(
                              onTap: () => setState(() => selectedColor = i),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: colors[i],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedColor == i ? Colors.blue : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Checkbox(
                        value: isFill,
                        onChanged: (v) => setState(() => isFill = v ?? true),
                        activeColor: Colors.blue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const Text('Fill'),
                    ],
                  ),
                ),
                // Size slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Size', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Slider(
                          value: size,
                          onChanged: (v) => setState(() => size = v),
                          min: 0.1,
                          max: 1.0,
                          activeColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

