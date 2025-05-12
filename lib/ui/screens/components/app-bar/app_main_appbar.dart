import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';

class AppMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? appBarSize;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;

  final bool isShowBackBtn;
  final bool showCrossIconInBackBtn;

  final Color bgColor;
  final bool isTitleCenter;
  final bool fromAuth;
  final bool isProfileCompleted;
  final List<Widget>? actions;

  final Widget? leadingWidget;
  final VoidCallback? leadingWidgetOnTap;

  const AppMainAppBar({
    super.key,
    this.fromAuth = false,
    this.isTitleCenter = true,
    this.bgColor = MyColor.primaryColorDark,
    this.isShowBackBtn = true,
    this.title,
    required this.isProfileCompleted,
    this.actions,
    this.titleStyle,
    this.titleWidget,
    this.appBarSize,
    this.leadingWidget,
    this.leadingWidgetOnTap,
    this.showCrossIconInBackBtn = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarSize ?? 60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: MyColor.getSystemStatusBarColor(), statusBarIconBrightness: MyColor.getSystemStatusBarBrightness(), systemNavigationBarColor: MyColor.getSystemNavigationBarColor(), systemNavigationBarIconBrightness: MyColor.getSystemNavigationBarBrightness()),
      surfaceTintColor: Colors.transparent,
      backgroundColor: bgColor,
      leading: (isShowBackBtn)
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: Dimensions.space15),
              child: Ink(
                decoration: ShapeDecoration(
                  color: MyColor.getAppBarBackgroundColor(),
                  shape: const CircleBorder(),
                ),
                child: FittedBox(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (leadingWidgetOnTap != null) {
                        leadingWidgetOnTap!();
                      } else {
                        if (fromAuth) {
                         // Get.offAllNamed(RouteHelper.authenticationScreen);
                        } else if (isProfileCompleted == false) {
                         // showExitDialog(Get.context!);
                        } else {
                          String previousRoute = Get.previousRoute;
                          if (previousRoute == '/splash-screen') {
                           // Get.offAndToNamed(RouteHelper.dashboardScreen);
                          } else {
                            Get.back();
                          }
                        }
                      }
                    },
                    icon: leadingWidget ??
                        Icon(
                          showCrossIconInBackBtn ? Icons.close : Icons.arrow_back,
                          color: MyColor.getAppBarContentColor(),
                          size: 25,
                        ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
      centerTitle: isTitleCenter,
      title: titleWidget ??
          Text(
            (title ?? '').tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ??
                boldMediumLarge.copyWith(
                  color: MyColor.getAppBarContentTextColor(),
                ),
          ),
      actions: actions,
    );
  }
}
