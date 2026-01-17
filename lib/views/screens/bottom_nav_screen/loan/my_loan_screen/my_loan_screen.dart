import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/core/utils/util.dart';
import 'package:finovelapp/data/controller/loan/my_loan_controller.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/appbar/custom_appbar.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/components/no_data/no_data_found.dart';
import 'package:finovelapp/views/components/text/label_text.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/my-loan-list/widget/bottom_sheet.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/widget/loan_list_card.dart';

class MyLoanScreen extends StatefulWidget {
  final bool isBack;
  const MyLoanScreen({this.isBack=false, super.key});

  @override
  State<MyLoanScreen> createState() => _MyLoanScreenState();
}

class _MyLoanScreenState extends State<MyLoanScreen> {
  final ScrollController scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  fetchData() {
    Get.find<MyLoanController>().loadPaginationData();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<MyLoanController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoanRepo(apiClient: Get.find()));
    final myloan = Get.put(MyLoanController(loanRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myloan.initialSelectedValue();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('previous route : ${Get.previousRoute}');
    return GetBuilder<MyLoanController>(builder: (controller) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.myLoan,
          isShowBackBtn: (Get.previousRoute == MyStrings.menu ) || (Get.previousRoute == '/bottom_nav_screen')   ? true : false,
          action: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.only(end: Dimensions.space15),
              child: GestureDetector(
                onTap: () {
                  controller.changeSearchIcon();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: MyColor.colorWhite, shape: BoxShape.circle),
                  child: controller.isSearch
                      ? const Icon(Icons.clear,
                          color: MyColor.primaryColor, size: 15)
                      : Image.asset(
                          MyImages.filter,
                          color: MyColor.primaryColor,
                          height: 15,
                          width: 15,
                        ),
                ),
              ),
            ),
            const SizedBox(
              width: Dimensions.space10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Visibility(
                  visible: controller.isSearch,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 13),
                    margin: const EdgeInsets.only(bottom: Dimensions.cardMargin),
                    decoration: BoxDecoration(
                      color: MyColor.getCardBg(),
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                      boxShadow: MyUtil.getBottomSheetShadow(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const LabelText(text: MyStrings.loanNumber),
                                  const SizedBox(height: Dimensions.space10),
                                  SizedBox(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    child: TextFormField(
                                      cursorColor: MyColor.primaryColor,
                                      style: interRegularSmall.copyWith(
                                          color: MyColor.colorBlack),
                                      keyboardType: TextInputType.text,
                                      controller: controller.srcController,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                        hintStyle: interRegularSmall.copyWith(
                                            color: MyColor.hintTextColor),
                                        filled: true,
                                        fillColor: MyColor.transparentColor,
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColor.colorGrey,
                                                width: 0.5)),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColor.colorGrey,
                                                width: 0.5)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: MyColor.primaryColor,
                                              width: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Dimensions.space10),
                            InkWell(
                              onTap: () {
                                controller.filterData();
                              },
                              child: Container(
                                height: 45,
                                width: 45,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: MyColor.primaryColor,
                                ),
                                child: const Icon(
                                  Icons.search_outlined,
                                  color: MyColor.colorWhite, size: 18
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: GetBuilder<MyLoanController>(builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        controller.loanStatus.length,
                        (i) => GestureDetector(
                          onTap: () {
                            controller.changeSelectedStatus(
                                controller.loanStatus[i]['value'].toString());
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: controller.selectedStatus.toString() == controller.loanStatus[i]['value'].toString()
                                      ? MyColor.primaryColor
                                      : MyColor.borderColor,
                                  width: 1),
                              color: controller.selectedStatus.toString() ==
                                      controller.loanStatus[i]['value']
                                          .toString()
                                  ? MyColor.primaryColor
                                  : MyColor.colorWhite,
                            ),
                            child: Center(
                              child: Text(
                                controller.loanStatus[i]['name'].toString(),
                                style: interLightMediumLarge.copyWith(
                                  color: controller.selectedStatus.toString() == controller.loanStatus[i]['value'].toString()
                                      ? MyColor.textColor
                                      : MyColor.colorBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: Dimensions.space20),
                controller.isLoading ?
                SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                child: const Center(
                  child: CustomLoader(
                    isFullScreen: true,
                  ),
                ),
              )
            : controller.myLoanList.isEmpty
              ? NoDataWidget(
                  topMargin: MediaQuery.of(context).size.height / 8,
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.myLoanList.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                  itemBuilder: (context, index) {
                    if (controller.myLoanList.length == index) {
                      return controller.hasNext()
                          ? const CustomLoader(isPagination: true)
                          : const SizedBox();
                    }
                    return LoanListCard(
                      currency: controller.currency,
                      loanName: controller.myLoanList[index].plan?.name ?? '',
                      statusColor: controller.getStatusAndColor(index, isStatus: false),
                      status: controller.getStatusAndColor(index, isStatus: true),
                      amount: controller.myLoanList[index].amount ?? '',
                      loanNumber: controller.myLoanList[index].loanNumber ?? '',
                      press: () {
                        LoanListBottomSheet().bottomSheet(context, index);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
