import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/no_data/no_data_found.dart';

import '../../../../core/utils/my_color.dart';
import '../../../core/utils/dimensions.dart';

class NoDataOrInternetScreen extends StatefulWidget {
  const NoDataOrInternetScreen({
    super.key,
    this.message = MyStrings.noDataFound,
    this.paddingTop = 6,
    this.imageHeight = .5,
    this.fromReview = false,
    this.isNoInternet = false,
    this.onChanged,
    this.message2 = MyStrings.noDataFound,
    this.image = MyImages.noDataImage,
  });
  final String message;
  final double paddingTop;
  final double imageHeight;
  final bool fromReview;
  final bool isNoInternet;
  final Function? onChanged;
  final String message2;
  final String image;

  @override
  State<NoDataOrInternetScreen> createState() => _NoDataOrInternetScreenState();
}

class _NoDataOrInternetScreenState extends State<NoDataOrInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: widget.isNoInternet
          ? ListView(
              physics: widget.fromReview
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          widget.imageHeight,
                      width: widget.isNoInternet
                          ? MediaQuery.of(context).size.width * .6
                          : MediaQuery.of(context).size.width * .33,
                      child: widget.isNoInternet
                          ? Lottie.asset(
                              MyImages.noInternet,
                              height: MediaQuery.of(context).size.height *
                                  widget.imageHeight,
                              width: MediaQuery.of(context).size.width * .6,
                            )
                          : SvgPicture.asset(
                              widget.image,
                              height: 100,
                              width: 100,
                              color: MyColor.getGreyText(),
                            ),
                    ),
                    Center(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(top: 6, left: 30, right: 30),
                      child: Column(
                        children: [
                          Text(
                            (widget.isNoInternet
                                    ? MyStrings.noInternet
                                    : widget.message)
                                .tr,
                            textAlign: TextAlign.center,
                            style: interSemiBold.copyWith(
                                color: widget.isNoInternet
                                    ? MyColor.redCancelTextColor
                                    : MyColor.colorGrey2,
                                fontSize: Dimensions.fontLarge),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          widget.isNoInternet
                              ? const SizedBox()
                              : Text(
                                  widget.message2.tr,
                                  style: interRegularDefault.copyWith(
                                      color: MyColor.textColor,
                                      fontSize: Dimensions.fontLarge),
                                  textAlign: TextAlign.center,
                                ),
                          widget.isNoInternet
                              ? const SizedBox(
                                  height: 15,
                                )
                              : const SizedBox(),
                          widget.isNoInternet
                              ? RoundedButton(
                                text: MyStrings.retry,
                                color: MyColor.redCancelTextColor,
                                borderColor: MyColor.redCancelTextColor,
                                textColor: MyColor.colorWhite,
                                press: () async {
                                  if (await Connectivity()
                                  .checkConnectivity() !=
                                  ConnectivityResult.none) {
                                  widget.onChanged!(true);
                                  }
                                },
                              )
                              : const SizedBox()
                        ],
                      ),
                    )),
                  ],
                )
              ],
            )
          : const NoDataWidget(),
    );
  }
}
