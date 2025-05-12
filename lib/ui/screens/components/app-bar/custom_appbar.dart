import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/data/services/api_service.dart';
import 'package:nexus/ui/screens/components/app-bar/action_button_icon_widget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/my_color.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isShowBackBtn;
  final Color bgColor;
  final bool isShowActionBtn;
  final bool isTitleCenter;
  final bool fromAuth;
  final bool isProfileCompleted;
  final dynamic actionIcon;
  final VoidCallback? actionPress;
  final bool isActionIconAlignEnd;
  final String actionText;
  final bool isActionImage;

  const CustomAppBar({
    super.key,
    this.isProfileCompleted = false,
    this.fromAuth = false,
    this.isTitleCenter = false,
    this.bgColor = MyColor.primaryColorDark,
    this.isShowBackBtn = true,
    required this.title,
    this.isShowActionBtn = false,
    this.actionText = '',
    this.actionIcon,
    this.actionPress,
    this.isActionIconAlignEnd = false,
    this.isActionImage = true,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool hasNotification = false;
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShowBackBtn
        ? AppBar(
            elevation: 0,
            titleSpacing: 0,
            leading: widget.isShowBackBtn
                ? IconButton(
                    onPressed: () {
                      if (widget.fromAuth) {
                       // Get.offAllNamed(RouteHelper.authenticationScreen);
                      } else if (widget.isProfileCompleted) {
                       // showExitDialog(Get.context!);
                      } else {
                        String previousRoute = Get.previousRoute;
                        if (previousRoute == '/splash-screen') {
                        //  Get.offAndToNamed(RouteHelper.dashboardScreen);
                        } else {
                          Get.back();
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios, color: MyColor.getAppBarContentColor(), size: 20))
                : const SizedBox.shrink(),
            backgroundColor: widget.bgColor,
            title: Text(widget.title.tr, style: regularDefault.copyWith(color: MyColor.getAppBarContentColor())),
            centerTitle: widget.isTitleCenter,
            actions: [
              widget.isShowActionBtn
                  ? ActionButtonIconWidget(
                      pressed: widget.actionPress!,
                      isImage: widget.isActionImage,
                      icon: widget.isActionImage ? Icons.add : widget.actionIcon, //just for demo purpose we put it here
                      imageSrc: widget.isActionImage ? widget.actionIcon : '',
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                width: 5,
              )
            ],
          )
        : AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: widget.bgColor,
            title: Text(widget.title.tr, style: regularLarge.copyWith(color: MyColor.getPrimaryTextColor())),
            actions: [
              widget.isShowActionBtn
                  ? InkWell(
                      onTap: () {
                        // Get.toNamed(RouteHelper.notificationScreen)?.then((value) {
                        //   setState(() {
                        //     hasNotification = false;
                        //   });
                        // });
                      },
                      child: const SizedBox.shrink())
                  : const SizedBox()
            ],
            automaticallyImplyLeading: false,
          );
  }
}
