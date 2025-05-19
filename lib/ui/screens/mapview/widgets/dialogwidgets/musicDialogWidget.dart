import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicDialogWidget extends StatefulWidget {
  const MusicDialogWidget({super.key});

  @override
  State<MusicDialogWidget> createState() => _MusicDialogWidgetState();
}

class _MusicDialogWidgetState extends State<MusicDialogWidget> {
  int selectedMusic = 1;
  final List<Map<String, dynamic>> musicOptions = [
    {'icon': Icons.block, 'label': 'None'},
    {'icon': Icons.play_arrow, 'label': 'Light'},
    {'icon': Icons.play_arrow, 'label': 'Classical'},
    {'icon': Icons.play_arrow, 'label': 'Nostalgic'},
    {'icon': Icons.play_arrow, 'label': 'Rhythmic'},
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
                    'Music',
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
            // Music selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(musicOptions.length, (i) {
                  final selected = selectedMusic == i;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMusic = i),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: selected ? Colors.blue.withOpacity(0.08) : Colors.grey[100],
                        border: Border.all(
                          color: selected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(musicOptions[i]['icon'], size: 32, color: selected ? Colors.blue : Colors.grey[700]),
                          const SizedBox(height: 8),
                          Text(
                            musicOptions[i]['label'],
                            style: TextStyle(
                              color: selected ? Colors.blue : Colors.black87,
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
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
