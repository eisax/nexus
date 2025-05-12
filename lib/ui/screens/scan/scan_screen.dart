import 'package:flutter/material.dart';
import 'package:nexus/ui/screens/scan/widget/scanCameraViewScreen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();

  static Widget routeInstance() {
    return const ScanScreen();
  }
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScanCameraView();
  }
}
