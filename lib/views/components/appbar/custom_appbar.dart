import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/appbar/action_button_icon_widget.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isShowBackBtn;
  final Color bgColor;
  final bool isShowActionBtn;
  final bool isTitleCenter;
  final bool fromAuth;
  final bool isProfileCompleted;
  final dynamic actionIcon;
  final List<Widget>? action;
  final VoidCallback? actionPress;
  final bool isActionIconAlignEnd;
  final String actionText;
  final bool isActionImage;
  TextStyle? titleStyle;
  Color? iconColor;
  final bool isForceBackHome;
  CustomAppBar(
      {super.key,
      this.isProfileCompleted = false,
      this.fromAuth = false,
      this.isTitleCenter = false,
      this.bgColor = MyColor.primaryColor,
      this.isShowBackBtn = true,
      required this.title,
      this.isShowActionBtn = false,
      this.actionText = '',
      this.actionIcon,
      this.actionPress,
      this.isActionIconAlignEnd = false,
      this.isActionImage = true,
      this.action,
      this.titleStyle,
      this.isForceBackHome = false,
      this.iconColor = MyColor.colorWhite});

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
                      log('start');
                      if (widget.fromAuth) {
                        Get.offAllNamed(RouteHelper.loginScreen);
                      } else {
                        String previousRoute = Get.previousRoute;
                        if (previousRoute == '/splash-screen' ||
                            widget.isForceBackHome == true) {
                          Get.offAndToNamed(RouteHelper.bottomNavScreen);
                        } else {
                          Get.back();
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_back,
                        color: widget.iconColor, size: 20),
                  )
                : const SizedBox.shrink(),
            backgroundColor: widget.bgColor,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.title.tr,
                style: widget.titleStyle ??
                    interRegularLarge.copyWith(color: MyColor.textColor),
              ),
            ),
            centerTitle: widget.isTitleCenter,
            actions: widget.action ??
                [
                  widget.isShowActionBtn
                      ? ActionButtonIconWidget(
                          pressed: widget.actionPress!,
                          isImage: widget.isActionImage,
                          icon: widget.isActionImage
                              ? Icons.add
                              : widget
                                  .actionIcon, //just for demo purpose we put it here
                          imageSrc:
                              widget.isActionImage ? widget.actionIcon : '',
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
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.title.tr,
                style: widget.titleStyle ??
                    interRegularLarge.copyWith(
                      color: MyColor.textColor,
                    ),
              ),
            ),
            actions: widget.action ??
                [
                  widget.isShowActionBtn
                      ? InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.notificationScreen)
                                ?.then((value) {
                              setState(() {
                                hasNotification = false;
                              });
                            });
                          },
                          child: const SizedBox.shrink())
                      : const SizedBox()
                ],
            automaticallyImplyLeading: false,
          );
  }
}
