import 'package:finovelapp/core/route/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/controller/common/theme_controller.dart';
import 'package:finovelapp/data/controller/faq_controller/faq_controller.dart';
import 'package:finovelapp/data/repo/faq_repo/faq_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/appbar/custom_appbar.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/screens/about/faq/faq_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    ThemeController themeController =
        Get.put(ThemeController(sharedPreferences: Get.find()));
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(FaqRepo(apiClient: Get.find()));
    final controller = Get.put(FaqController(faqRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
            isShowBackBtn: true,
            title: MyStrings.faq.tr,
            bgColor: MyColor.getAppbarBgColor()),
            floatingActionButton:  FloatingActionButton(
              onPressed: () {
                Get.toNamed(RouteHelper.tawkToScreen);


              },
              backgroundColor: MyColor.lPrimaryColor,
              child: const  Icon(Icons.chat),
            ),
        body: GetBuilder<FaqController>(
          builder: (controller) => controller.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  padding: Dimensions.screenPaddingHV,
                  physics: const BouncingScrollPhysics(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.faqList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemBuilder: (context, index) => FaqListItem(
                        answer:
                            (controller.faqList[index].dataValues?.answer ??
                                    '')
                                .tr,
                        question:
                            (controller.faqList[index].dataValues?.question ??
                                    '')
                                .tr,
                        index: index,
                        press: () {
                          controller.changeSelectedIndex(index);
                        },
                        selectedIndex: controller.selectedIndex),
                  ),
                ),
        ));
  }
}
