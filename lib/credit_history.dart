import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/notifications/notification_controller.dart';
import 'package:finovelapp/data/repo/notification_repo/notification_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditHistory extends StatefulWidget {
  const CreditHistory({super.key});

  @override
  State<CreditHistory> createState() => _CreditHistoryState();
}

class _CreditHistoryState extends State<CreditHistory> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(NotificationRepo(apiClient: Get.find()));
    final controller = Get.put(NotificationsController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.page = 0;
      controller.clickIndex = -1;
      controller.initData();
    });
  }

  Future<void> _refreshData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAndroidRefreshControl(context),
    );
  }

  Widget _buildAndroidRefreshControl(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: MyColor.accentColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildPageContent(context),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/imgs/header_bg.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 52),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      printInfo(info: 'i am printed');
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      color: MyColor.whiteColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15,),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'FINOVEL',
                      style: TextStyle(
                          color: MyColor.whiteColor,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'TitilliumWeb',
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  GetBuilder<NotificationsController>(
                    builder: (controller) {
                      return GestureDetector(
                        onTap: () {
                          print('tapped notification icon');
                          Get.toNamed(RouteHelper.notificationScreen);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: controller.hasUnreadNotifications()
                                ? Colors.red
                                : MyColor.whiteColor,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no_transaction.jpg',
                width: screenWidth * 0.4,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Transactions Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Looks like you haven’t made any transactions yet.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
