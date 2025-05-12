import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class FullViewScreen extends StatefulWidget {
  const FullViewScreen({super.key});

  @override
  State<FullViewScreen> createState() => _FullViewScreenState();

  static Widget routeInstance() {
    return const FullViewScreen();
  }
}

class _FullViewScreenState extends State<FullViewScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProjectListPage();
  }
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Panorama(
        child: Image.asset('assets/images/panorama/pano-1.jpg'), 
      ),
    );
  }
}
