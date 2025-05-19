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

class EntryDialogWidget extends StatefulWidget {
  const EntryDialogWidget({super.key});

  @override
  State<EntryDialogWidget> createState() => _EntryDialogWidgetState();
}

class _EntryDialogWidgetState extends State<EntryDialogWidget> {
  int selectedEntry = 0;
  final List<Map<String, dynamic>> entries = [
    {'label': 'Panorama Access', 'image': 'assets/images/panorama.jpg'},
    {'label': 'Model Jogging', 'image': 'assets/images/modeljogging.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
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
                    'Entry',
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
            // Entry selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(entries.length, (i) {
                  final selected = selectedEntry == i;
                  return GestureDetector(
                    onTap: () => setState(() => selectedEntry = i),
                    child: Container(
                      width: 160,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(entries[i]['image']),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: selected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                entries[i]['label'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (selected)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(Icons.check_circle, color: Colors.blue, size: 28),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
