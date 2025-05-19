import 'package:flutter/material.dart';
import 'package:nexus/ui/screens/navigation/widget/navigationCameraViewWidget.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();

  static Widget routeInstance() {
    return const NavigationScreen();
  }
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return const NavigationCameraView();
  }
}
