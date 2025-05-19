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

class GuideDialogWidget extends StatefulWidget {
  const GuideDialogWidget({super.key});

  @override
  State<GuideDialogWidget> createState() => _GuideDialogWidgetState();
}

class _GuideDialogWidgetState extends State<GuideDialogWidget> {
  List<Map<String, dynamic>> guides = [
    {'label': 'Dining', 'image': 'assets/images/dining.jpg'},
    {'label': 'Kitchen', 'image': 'assets/images/kitchen.jpg'},
    {'label': 'Living Room', 'image': 'assets/images/livingroom.jpg'},
  ];
  List<bool> selected = [false, false, false];

  void clearAll() {
    setState(() {
      selected = List.filled(guides.length, false);
    });
  }

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
                    'Guide',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: clearAll,
                        child: Row(
                          children: const [
                            Icon(Icons.delete_outline, color: Colors.blue, size: 22),
                            SizedBox(width: 4),
                            Text('Clear All', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.check, color: Colors.blue, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Guide selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: guides.length + 1,
                  itemBuilder: (context, i) {
                    if (i == guides.length) {
                      // Add button
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 36, color: Colors.blue),
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(guides[i]['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
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
                                guides[i]['label'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.edit, size: 18, color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
