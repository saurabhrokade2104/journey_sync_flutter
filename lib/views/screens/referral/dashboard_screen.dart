
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/account/profile_controller.dart';
import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/data/controller/leads/summary_controller.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/data/repo/account/profile_repo.dart';
import 'package:finovelapp/data/repo/auth/general_setting_repo.dart';
import 'package:finovelapp/data/repo/home/home_repo.dart';

import 'package:finovelapp/data/repo/leads/summar_repo.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:finovelapp/data/controller/menu_/menu_controller.dart' as menu;

class DashboardScreen extends StatefulWidget {
   const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoanRepo(apiClient: Get.find()));

    Get.put(HomeRepo(apiClient: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(SalesSummaryRepo(apiClient: Get.find()));

    final planController = Get.put(LoanPlanController(loanRepo: Get.find()));
    final controller = Get.put(HomeController(repo: Get.find()));
    final summaryController = Get.put(SalesSummaryController(salesSummaryRepo: Get.find()));
    final menuController = Get.put(menu.MenuController(repo: Get.find()));

    Get.put(ProfileRepo(
      apiClient: Get.find(),
    ));
    Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      summaryController.fetchUserStatus();
      controller.loadData();
      planController.loadLoanPlan();
      menuController.loadData();
      Get.find<ProfileController>().loadProfileInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      drawer: drawerWidget(context),
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  'assets/imgs/header_bg1.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 190.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 42.h,
                  left: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            printInfo(info: 'i am printed');
                            _scaffoldKey.currentState?.openDrawer();
                            // Builder(
                            //   builder: (context) {
                            //     Scaffold.of(context).openDrawer();
                            //     return Container(); // Return an empty container for the builder
                            //   },
                            // );
                          },
                          child: const Icon(
                            Icons.menu,
                            color: MyColor.whiteColor,
                            size: 24,
                          ),
                        ),
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
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Image.asset(
                              "assets/imgs/notification.png",
                              height: 40.h,
                              width: 40.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19.0),
            child: Column(
              children: [
                salesDashboardContainer(context, "My Sales Dashboard", () {
                  Navigator.pushNamed(context, '/mysalesdashboard');
                }),
                SizedBox(height: 30.h),
                salesDashboardContainer(context, "Channel Partners Dashboard",
                    () {
                  Navigator.pushNamed(context, '/channelscreen');
                }),
                SizedBox(height: 30.h),
                salesDashboardContainer(context, "My All Revenue", () {
                  Navigator.pushNamed(context, '/revenuescreen');
                }),
              ],
            ),
          ),
          const Spacer(),  // This will push the Lottie animation to the bottom
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Lottie.asset(
            "assets/images/india.json",
          ),
        ),
        ],
      ),
    );
  }
}

Widget salesDashboardContainer(
    BuildContext context, String title, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    ),
  );
}
