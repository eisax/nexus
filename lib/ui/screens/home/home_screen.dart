// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/ui/screens/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:nexus/ui/screens/home/widget/project_options.dart';
import 'package:nexus/utils/my_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Widget routeInstance() {
    return HomeScreen();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ProjectListPage();
  }
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffedf3fc),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(expandedHeight: 130),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ProjectCard(
                name: index < 2 ? "CUT CAMPUS" : "CUT CAMPUS",
                date: index < 2 ? "2025-03-20" : "2025-01-02",
                location: index < 2 ? "Phone" : "Galois",
              );
            }, childCount: 10),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        height: 105,
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(RouteHelper.selectdevice),
                child: SizedBox(
                  width: 80,
                  height: 75,
                  child: Image(
                    image: AssetImage(
                      "assets/images/bg_poincare_connected.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.scan),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bg_btn_shoot.png"),
                          fit: BoxFit.cover,
                        ),

                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Scan Map",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  const CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [_buildBackground(shrinkOffset), _buildAppBar(shrinkOffset)],
    );
  }

  double _appear(double shrinkOffset) => shrinkOffset / expandedHeight;
  double _disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget _buildAppBar(double shrinkOffset) {
    return Opacity(
      opacity: _appear(shrinkOffset),
      child: AppBar(
        backgroundColor: Color(0xffedf3fc),
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteHelper.profileandsettings),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffedf3fc),
                          border: Border.all(color: Colors.white, width: 1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/person.svg',
                          width: 15,
                          height: 15,
                          fit: BoxFit.fitHeight,
                          color: Color(0xFF318BDF),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF2A8BE7), Color(0xFF318BDF)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          size: 7,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "eisax",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "eisax's team",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(RouteHelper.notification),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: 30,
                    height: 30,

                    child: SvgPicture.asset(
                      'assets/images/bell_simple.svg',
                      width: 15,
                      height: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildBackground(double shrinkOffset) {
    return Opacity(
      opacity: _disappear(shrinkOffset),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/bg_main_activity_personal_top.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap:
                                () =>
                                    Get.toNamed(RouteHelper.profileandsettings),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xffedf3fc),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/person.svg',
                                width: 15,
                                height: 15,
                                fit: BoxFit.fitHeight,
                                color: Color(0xFF318BDF),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF2A8BE7),
                                    Color(0xFF318BDF),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.more_horiz,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Text(
                        "eisax",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xffedf3fc),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/bell_simple.svg',
                          width: 15,
                          height: 15,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Maps",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/search_simple.svg',
                        width: 20,
                        height: 20,
                        fit: BoxFit.fitHeight,
                        color: Color(0xFF121212),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/images/sort_simple.svg',
                        width: 20,
                        height: 20,
                        fit: BoxFit.fitHeight,
                        color: Color(0xFF121212),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Optional: Reusable button builder
  Widget buildButton({required String text, required IconData icon}) {
    return TextButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ProjectCard extends StatelessWidget {
  final String name;
  final String date;
  final String location;

  const ProjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.mapview),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_card_default.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$date | $location',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 101, 99, 99),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        CustomBottomSheetPlus(
                          child: ProjectOptionsDialogWidget(),
                          isNeedPadding: false,
                          bgColor: MyColor.transparentColor,
                        ).show(context);
                      },
                      child: Icon(Icons.more_vert, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
