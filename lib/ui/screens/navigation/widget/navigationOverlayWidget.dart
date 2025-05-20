import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/screens/components/textfield/customTextfieldWidget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';
import 'package:nexus/utils/my_images.dart';
import 'package:nexus/utils/util.dart';
import 'dart:ui';

class NavigationOverlayWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const NavigationOverlayWidget({super.key, required this.onCheckTip});

  @override
  State<NavigationOverlayWidget> createState() =>
      _NavigationOverlayWidgetState();
}

class _NavigationOverlayWidgetState extends State<NavigationOverlayWidget> {
  final List<String> filters = [
    'Engineering',
    'Business',
    'Natural Science',
    'Shops',
    'Parks',
    'Museums',
  ];
  int selectedFilter = 0;

  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/city_street.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          if (isNavigating) ...[
            _buildNavigationOverlay(),
          ] else ...[
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.space15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    width: Get.width,
                    child: Row(
                      children: [
                        CustomSvgPicture(
                          image: MyIcons.search,
                          color: MyColor.getTextFieldHintColor(),
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomTextField(
                              hintText: 'Search for a destination',
                              animatedLabel: false,
                              fillColor: Colors.white,
                              textInputType: MyUtils.getInputTextFieldType(
                                "text",
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        CustomSvgPicture(
                          image: MyIcons.mic,
                          color: MyColor.getTextFieldHintColor(),
                          height: 20,
                          width: 20,
                        ),
                        horizontalSpace(Dimensions.space10),
                        CircleAvatar(
                          radius: 13,
                          child: MyLocalImageWidget(
                            imagePath: MyImages.tinder,
                            height: 26,
                            width: 26,
                            radius: 50,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final selected = selectedFilter == i;
                        return ChoiceChip(
                          label: Text(filters[i]),
                          selected: selected,
                          onSelected: (_) => setState(() => selectedFilter = i),
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.blue : Colors.black87,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          side: BorderSide(
                            color:
                                selected ? Colors.blue : Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 33,
              child: SizedBox(
                height: Get.height * 0.3,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space17,
                      ),
                      child: SizedBox(
                        width: Get.width,
                        child: MyLocalImageWidget(
                          imagePath: MyImages.library,
                          boxFit: BoxFit.fill,
                          radius: 28,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space30,
                              vertical: Dimensions.space15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.space10,
                                        vertical: Dimensions.space7,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.55),
                                        borderRadius: BorderRadius.circular(32),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomSvgPicture(
                                            image: MyIcons.solidTick,
                                            color: MyColor.getCardBgColor(),
                                            height: 18,
                                            width: 18,
                                          ),
                                          horizontalSpace(Dimensions.space3),
                                          Text(
                                            'Back to list',
                                            style: regularDefault.copyWith(
                                              color: MyColor.getCardBgColor(),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Row(
                                  children: [
                                    //route
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY: 5,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions.space7,
                                            vertical: Dimensions.space7,
                                          ),
                                          margin: const EdgeInsets.only(
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.55,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomSvgPicture(
                                                image: MyIcons.distance_simple,
                                                color: MyColor.getCardBgColor(),
                                                height: 18,
                                                width: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    horizontalSpace(Dimensions.space7),
                                    //call
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY: 5,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions.space7,
                                            vertical: Dimensions.space7,
                                          ),
                                          margin: const EdgeInsets.only(
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.55,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomSvgPicture(
                                                image: MyIcons.callCircle,
                                                color: MyColor.getCardBgColor(),
                                                height: 18,
                                                width: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    horizontalSpace(Dimensions.space7),
                                    //help
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY: 5,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions.space7,
                                            vertical: Dimensions.space7,
                                          ),
                                          margin: const EdgeInsets.only(
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.55,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomSvgPicture(
                                                image: MyIcons.helpCircle,
                                                color: MyColor.getCardBgColor(),
                                                height: 18,
                                                width: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18,
                                            horizontal: 18,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                alignment: WrapAlignment.center,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Text(
                                                    'New Canteen Ext',
                                                    style: boldOverLarge.copyWith(
                                                      fontSize:
                                                          Dimensions
                                                              .fontExtraLarge,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  CustomSvgPicture(
                                                    image: MyIcons.star,
                                                    color: Colors.amber,
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  horizontalSpace(
                                                    Dimensions.space7,
                                                  ),
                                                  Text(
                                                    '4.5',
                                                    style: regularExtraLarge
                                                        .copyWith(
                                                          color:
                                                              MyColor.getGreyText(),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  CustomSvgPicture(
                                                    image: MyIcons.speed_solid,
                                                    color:
                                                        MyColor.getGreyText(),
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                  horizontalSpace(
                                                    Dimensions.space3,
                                                  ),
                                                  Text(
                                                    'Est. 17 min',
                                                    style: regularDefault.copyWith(
                                                      color:
                                                          MyColor.getGreyText(),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '16:03',
                                                    style: regularDefault.copyWith(
                                                      color:
                                                          MyColor.getGreyText(),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '1.3 km',
                                                    style: regularDefault.copyWith(
                                                      color:
                                                          MyColor.getGreyText(),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // GO button
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 18,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isNavigating = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFB6F36B),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 18,
                                              vertical: 18,
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'GO',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildNavigationOverlay() {
    return Stack(
      children: [
        // Top black pill
        Positioned(
          top: 60,
          left: 16,
          right: 16,
          child: Center(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      CustomSvgPicture(
                        image: MyIcons.turnLeft,
                        color: MyColor.getTextFieldHintColor(),
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        '150m',
                        style: boldLarge.copyWith(
                          color: MyColor.getCardBgColor(),
                        ),
                      ),
                    ],
                  ),
                  horizontalSpace(Dimensions.space10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Dining Hall',
                            style: boldExtraLarge.copyWith(
                              color: MyColor.getCardBgColor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Turn left',
                        style: regularLarge.copyWith(
                          color: MyColor.getCardBgColor().withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Blue AR path with arrows (placeholder)
        Positioned.fill(
          bottom: 0,
          child: IgnorePointer(child: CustomPaint(painter: _ARPathPainter())),
        ),
        // Floating round action buttons
        Positioned(
          right: 18,
          bottom: 150,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space7,
                      vertical: Dimensions.space7,
                    ),
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomSvgPicture(
                      image: MyIcons.search,
                      color: MyColor.getCardBgColor(),
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ),
              verticalSpace(Dimensions.space7),
              //call
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space7,
                      vertical: Dimensions.space7,
                    ),
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomSvgPicture(
                      image: MyIcons.callCircle,
                      color: MyColor.getCardBgColor(),
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ),
              verticalSpace(Dimensions.space7),
              //help
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space7,
                      vertical: Dimensions.space7,
                    ),
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomSvgPicture(
                      image: MyIcons.distance_simple,
                      color: MyColor.getCardBgColor(),
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Center(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Arrival in ',
                            style: regularDefault.copyWith(
                              color: MyColor.getGreyText(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '14 min',
                            style: boldExtraLarge.copyWith(
                              color: MyColor.getHeadingTextColor(),
                            ),
                          ),
                        ],
                      ),
                      horizontalSpace(Dimensions.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'After ',
                            style: regularDefault.copyWith(
                              color: MyColor.getGreyText(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '1.9 km',
                            style: regularExtraLarge.copyWith(
                              color: MyColor.getHeadingTextColor().withOpacity(
                                0.75,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      horizontalSpace(Dimensions.space12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'At ',
                            style: regularDefault.copyWith(
                              color: MyColor.getGreyText(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '16:03',
                            style: regularExtraLarge.copyWith(
                              color: MyColor.getHeadingTextColor().withOpacity(
                                0.75,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isNavigating = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class _ARPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient background for the main shape
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
      colors: [
        const Color(0xFF3A7BFF).withOpacity(0.6),
        const Color(0xFF3A7BFF).withOpacity(0.0),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height); // Bottom-left
    path.lineTo(size.width * 0.9, size.height); // Bottom-right
    path.lineTo(size.width * 0.6, size.height * 0.6); // Top-right
    path.lineTo(size.width * 0.5, size.height * 0.6); // Top-left
    path.close();
    canvas.drawPath(path, paint);

    // Arrow base dimensions
    final baseTop = -12.0;
    final baseBottom = 10.0;

    final startY = size.height * 0.85;
    final endY = size.height * 0.45;
    final step = size.height * 0.12;

    for (double y = startY; y > endY; y -= step) {
      final progress = (startY - y) / (startY - endY);
      final scale = 1.0 - progress * 0.6; // From 1.0 to 0.4
      final opacity = 1.0 - progress;     // From 1.0 to 0.0

      final arrowPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Use canvas transform to scale without changing base dimensions
      canvas.save();
      canvas.translate(size.width * 0.55, y);
      canvas.scale(scale);

      final arrowPath = Path();
      arrowPath.moveTo(0, baseTop); // top center
      arrowPath.lineTo(-10, baseBottom); // bottom left
      arrowPath.lineTo(10, baseBottom); // bottom right
      arrowPath.close();

      canvas.drawPath(arrowPath, arrowPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
