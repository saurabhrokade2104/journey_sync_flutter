import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/date_converter.dart';
import 'package:finovelapp/core/helper/string_format_helper.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/deposit/deposit_history_controller.dart';
import 'package:finovelapp/data/repo/deposit/deposit_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/components/no_data/no_data_found_screen.dart';
import 'package:finovelapp/views/screens/deposits/widget/custom_deposits_card.dart';
import 'package:finovelapp/views/screens/deposits/widget/deposit_bottom_sheet.dart';
import 'package:finovelapp/views/screens/deposits/widget/deposit_history_top.dart';

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  State<DepositsScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final ScrollController scrollController = ScrollController();

  fetchData() {
    Get.find<DepositController>().fetchNewList();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<DepositController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DepositRepo(apiClient: Get.find()));
    final controller = Get.put(DepositController(depositRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.beforeInitLoadData();
      scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.containerBgColor,
        appBar: AppBar(
          title: Text(MyStrings.deposits,
              style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
          backgroundColor: MyColor.primaryColor,
          elevation: 0,
          actions: [
            //attention: uncomment if you want to enable filter system
            // GestureDetector(
            //   onTap: () {
            //     controller.changeIsPress();
            //   },
            //   child: Container(
            //       padding: const EdgeInsets.all(Dimensions.space7),
            //       decoration: const BoxDecoration(
            //           color: MyColor.colorWhite, shape: BoxShape.circle),
            //       child: Icon(
            //           controller.isSearch ? Icons.clear : Icons.search,
            //           color: MyColor.primaryColor,
            //           size: 15)),
            // ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.newDepositScreenScreen);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 7, right: 10, bottom: 7, top: 7),
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, shape: BoxShape.circle),
                child: const Icon(Icons.add,
                    color: MyColor.primaryColor, size: 15),
              ),
            ),
            const SizedBox(width: Dimensions.space7),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.space20,
                    left: Dimensions.space15,
                    right: Dimensions.space15),
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.isSearch,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DepositHistoryTop(),
                          SizedBox(height: Dimensions.space15),
                        ],
                      ),
                    ),
                    Expanded(
                      child: controller.depositList.isEmpty &&
                              controller.searchLoading == false
                          ? NoDataFoundScreen(
                              title: MyStrings.noDepositFound,
                              height: controller.isSearch ? 0.75 : 0.8)
                          : controller.searchLoading
                              ? const Center(
                                  child: CustomLoader(),
                                )
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        controller.depositList.length + 1,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                            height: Dimensions.space10),
                                    itemBuilder: (context, index) {
                                      if (controller.depositList.length ==
                                          index) {
                                        return controller.hasNext()
                                            ? SizedBox(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: const Center(
                                                  child: CustomLoader(),
                                                ),
                                              )
                                            : const SizedBox();
                                      }
                                      return CustomDepositsCard(
                                        onPressed: () {
                                          DepositBottomSheet
                                              .depositBottomSheet(
                                                  context, index);
                                        },
                                        trxValue: controller
                                                .depositList[index].trx ??
                                            "",
                                        date: DateConverter
                                            .isoToLocalDateAndTime(controller
                                                    .depositList[index]
                                                    .createdAt ??
                                                ""),
                                        status: controller.getStatus(index),
                                        statusBgColor:
                                            controller.getStatusColor(index),
                                        amount:
                                            "${Converter.formatNumber(controller.depositList[index].amount ?? " ")} ${controller.currency}",
                                      );
                                    },
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
