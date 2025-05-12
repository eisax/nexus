import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/screens/fullview/widgets/curve.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
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
  double height = 100;

  List<Offset> originalPoints = [
    Offset(Get.width / 5, 0),
    Offset(Get.width / 2.25, 20),
    Offset(Get.width - (Get.width / 3.24), 35),
    Offset(Get.width, 10),
  ];

  List<List<Offset>> points = [
    [
      Offset(Get.width / 5, 0),
      Offset(Get.width / 2.25, 20),
      Offset(Get.width - (Get.width / 3.24), 35),
      Offset(Get.width, 10),
    ],
  ];

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (details.delta.dy < 0) {
        points = [
          points[0]
              .map(
                (offset) => Offset(
                  offset.dx,
                  (offset.dy - 5).clamp(0, double.infinity),
                ),
              )
              .toList(),
        ];

        double totalProgress = 0;
        for (int i = 0; i < points[0].length; i++) {
          double original = originalPoints[i].dy;
          double current = points[0][i].dy;
          double progress = 1 - (current / original);
          totalProgress += progress.isNaN ? 1 : progress;
        }
        double averageProgress = totalProgress / points[0].length;
        height = 100 + (100 * averageProgress);
      } else if (details.delta.dy > 0) {
        points = [
          List.generate(points[0].length, (i) {
            double newY = (points[0][i].dy + 5);
            double originalY = originalPoints[i].dy;
            if (newY > originalY) newY = originalY;
            return Offset(points[0][i].dx, newY);
          }),
        ];

        double totalProgress = 0;
        for (int i = 0; i < points[0].length; i++) {
          double original = originalPoints[i].dy;
          double current = points[0][i].dy;
          double progress = 1 - (current / original);
          totalProgress += progress.isNaN ? 1 : progress;
        }
        double averageProgress = totalProgress / points[0].length;

        if (height > 100) {
          height = 100 - (100 * averageProgress);
        } else {
          height = 100;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Panorama(child: Image.asset('assets/images/panorama/pano-1.jpg')),
          // Top back button
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeArea(
                child: Container(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space15,
                      vertical: Dimensions.space7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all(Dimensions.space5),
                                child: SvgPicture.asset(
                                  "assets/images/left_arrow_simple.svg",
                                  fit: BoxFit.cover,
                                  color: const Color(0xFF5b6368),
                                ),
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Chinhoyi University",
                                    style: semiBoldLarge.copyWith(
                                      color: MyColor.getCardBgColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        //3 end icons
                        Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [
                                    Color(0xffFFFFFF).withOpacity(0.25),
                                    Color(0xffFFFFFF),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.center,
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: CustomSvgPicture(
                                image: "assets/icons/info.svg",
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                            horizontalSpace(Dimensions.space15),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [
                                    Color(0xffFFFFFF).withOpacity(0.25),
                                    Color(0xffFFFFFF),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.center,
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: CustomSvgPicture(
                                image: "assets/icons/share.svg",
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                            horizontalSpace(Dimensions.space15),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [
                                    Color(0xffFFFFFF).withOpacity(0.25),
                                    Color(0xffFFFFFF),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.center,
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: CustomSvgPicture(
                                image: "assets/images/interface/note.svg",
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    SizedBox(
                      height: height,
                      child: CustomPaint(
                        painter: WaveBorderPainter(
                          points: points,
                          borderColor: MyColor.getPrimaryColor().withOpacity(
                            0.4,
                          ),
                        ),
                        size: Size.infinite,
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      child: ClipPath(
                        clipper: WaveClipper(points: points),
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.space15),
                          height: height,
                          color: Colors.black.withOpacity(0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          GestureDetector(
                                            //  onTap:
                                            //   () => Get.toNamed(RouteHelper.profileandsettings),
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              width: 40,
                                              height: 40,
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
                                            left: 0,
                                            child: ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [
                                                    Color(0xff5f67fc),
                                                    Color(
                                                      0xff5f67fc,
                                                    ).withOpacity(0.75),
                                                  ],
                                                  begin: Alignment.center,
                                                  end: Alignment.bottomCenter,
                                                ).createShader(bounds);
                                              },
                                              blendMode: BlendMode.srcIn,
                                              child: CustomSvgPicture(
                                                image:
                                                    "assets/images/interface/list.svg",
                                                height: 18,
                                                width: 18,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      horizontalSpace(Dimensions.space10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "eisax",
                                                  style: semiBoldLarge.copyWith(
                                                    color:
                                                        MyColor.getCardBgColor(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          verticalSpace(Dimensions.space3),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "All in one XR navigation platform",
                                                  style: regularSmall.copyWith(
                                                    color:
                                                        MyColor.getContentTextColor(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Transform.rotate(
                                        angle: -45,
                                        child: CustomSvgPicture(
                                          image:
                                              "assets/images/interface/guide.svg",
                                          height: 22,
                                          width: 22,
                                          fit: BoxFit.cover,
                                          color: MyColor.getCardBgColor(),
                                        ),
                                      ),
                                      verticalSpace(Dimensions.space2),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Guide",
                                              style: regularSmall.copyWith(
                                                color: MyColor.getCardBgColor(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
