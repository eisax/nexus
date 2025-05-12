import 'package:flutter/material.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';

class AccountUserCard extends StatelessWidget {
  final String? username, fullName, subtitle;
  final String? image;
  final bool isAsset;
  final bool isLoading;
  final bool noAvatar;
  final TextStyle? titleStyle, subtitleStyle;
  final String? rating;
  final Widget? imgWidget;
  final Widget? rightWidget;
  final double? imgHeight;
  final double? imgwidth;
  final VoidCallback? onTap;
  const AccountUserCard({
    super.key,
    this.username,
    this.fullName,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.rightWidget,
    this.image = MyIcons.addAction,
    this.isAsset = true,
    this.noAvatar = false,
    this.rating,
    this.imgHeight,
    this.imgwidth,
    this.imgWidget,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return 
    
    // isLoading
    //     ? const AccountInfoCardLoaderShimmer()
    //     :
        
         GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (imgWidget != null)
                          imgWidget!
                        else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColor.primaryColorDark,
                            ),
                            child: const CustomSvgPicture(image: MyIcons.addAction),
                          ),
                        const SizedBox(
                          width: Dimensions.space15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  fullName.toString().toUpperCase(),
                                  style: titleStyle ??
                                      boldDefault.copyWith(
                                        color: MyColor.getPrimaryTextColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontLarge + 3,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.space3,
                              ),
                              Text(
                                "@$username",
                                style: titleStyle ??
                                    regularDefault.copyWith(
                                      color: MyColor.getPrimaryTextColor(),
                                      fontSize: Dimensions.fontSmall,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: Dimensions.space5,
                              ),
                              if (subtitle?.trim().toString() != "") ...[
                                Text(
                                  "+${subtitle?.trim().toString()}",
                                  style: subtitleStyle ?? regularDefault.copyWith(fontSize: Dimensions.fontSmall, color: MyColor.getPrimaryTextColor().withOpacity(0.8)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: Dimensions.space5,
                                ),
                              ],
                              if (rating != "hide") ...[
                                Container(
                                  decoration: BoxDecoration(
                                    color: MyColor.getScreenBgColor(),
                                    borderRadius: BorderRadius.circular(Dimensions.space20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.space10,
                                    vertical: Dimensions.space5,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: MyColor.pendingColor,
                                        size: Dimensions.fontLarge,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${rating?.trim().isEmpty ?? true ? 'N/A' : rating!} ",
                                        style: boldDefault.copyWith(
                                          fontSize: Dimensions.fontDefault,
                                          color: MyColor.getPrimaryTextColor(),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  rightWidget ?? const SizedBox.shrink()
                ],
              ),
            ),
          );
  }
}
