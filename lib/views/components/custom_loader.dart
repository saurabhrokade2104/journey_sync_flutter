import 'package:flutter/material.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoader extends StatelessWidget {
  final bool isFullScreen;
  final bool isPagination;
  final double strokeWidth;

  const CustomLoader(
      {super.key,
      this.isFullScreen = false,
      this.isPagination = false,
      this.strokeWidth = 1});

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: LoadingAnimationWidget.dotsTriangle(
              color: MyColor.primaryColor,
              size: 24.0,
            )),
          )
        : isPagination
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: MyColor.primaryColor,
                    size: 18,
                  ),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.dotsTriangle(
                color: MyColor.primaryColor,
                size: 22.0,
              ));
  }
}
