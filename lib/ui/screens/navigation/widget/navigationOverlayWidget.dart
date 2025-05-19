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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          // Background image (city street)
          Positioned.fill(
            child: Image.asset(
              'assets/images/city_street.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Top search bar and filters (unchanged)
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.space15),
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
                          color: selected ? Colors.blue : Colors.grey.shade300,
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
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space7,
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
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space7,
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
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space7,
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
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'New Canteen Ext',
                                          style: boldOverLarge.copyWith(
                                            fontSize: Dimensions.fontExtraLarge,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        CustomSvgPicture(
                                          image: MyIcons.star,
                                          color: Colors.amber,
                                          height: 20,
                                          width: 20,
                                        ),
                                        horizontalSpace(Dimensions.space7),
                                        Text(
                                          '4.5',
                                          style: regularExtraLarge.copyWith(
                                            color: MyColor.getGreyText(),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        CustomSvgPicture(
                                          image: MyIcons.speed_solid,
                                          color: MyColor.getGreyText(),
                                          height: 16,
                                          width: 16,
                                        ),
                                        horizontalSpace(Dimensions.space3),
                                        Text(
                                          'Est. 17 min',
                                          style: regularDefault.copyWith(
                                            color: MyColor.getGreyText(),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '16:03',
                                          style: regularDefault.copyWith(
                                            color: MyColor.getGreyText(),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '1.3 km',
                                          style: regularDefault.copyWith(
                                            color: MyColor.getGreyText(),
                                            fontWeight: FontWeight.w500,
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
                              padding: const EdgeInsets.only(right: 18),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFB6F36B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
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
    );
  }
}
