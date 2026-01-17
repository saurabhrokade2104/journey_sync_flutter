import 'dart:async';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/data/repo/leads/summar_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:finovelapp/data/controller/account/profile_controller.dart';
import 'package:finovelapp/data/controller/home/home_controller.dart';
import 'package:finovelapp/data/controller/leads/summary_controller.dart';
import 'package:finovelapp/data/controller/loan/loan_plan_controller.dart';
import 'package:finovelapp/data/repo/account/profile_repo.dart';
import 'package:finovelapp/data/repo/auth/general_setting_repo.dart';
import 'package:finovelapp/data/repo/home/home_repo.dart';
import 'package:finovelapp/data/repo/loan/loan_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:get/get.dart';
import 'package:finovelapp/data/controller/menu_/menu_controller.dart' as menu;

class MySalesDashboardScreen extends StatefulWidget {
  const MySalesDashboardScreen({super.key});

  @override
  State<MySalesDashboardScreen> createState() => _MySalesDashboardScreenState();
}

class _MySalesDashboardScreenState extends State<MySalesDashboardScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoanRepo(apiClient: Get.find()));

    Get.put(HomeRepo(apiClient: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(SalesSummaryRepo(apiClient: Get.find()));

    final planController = Get.put(LoanPlanController(loanRepo: Get.find()));
    final controller = Get.put(HomeController(repo: Get.find()));
    final summaryController =
        Get.put(SalesSummaryController(salesSummaryRepo: Get.find()));
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

  void _refreshScreen() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Container(
              color: Colors.black12,
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );

    try {
      await Get.find<SalesSummaryController>().fetchUserStatus();
    } catch (e) {
      // Handle any exceptions if necessary
      print('Error fetching user status: $e');
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
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
                            onTap: () => Navigator.popAndPushNamed(
                                context, '/dashboardscreen'),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0.w),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 15,
                                    color: AppColors.whiteColor,
                                  ),
                                  Text(
                                    'BACK',
                                    style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
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
                      Text(
                        'My Sales Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0.w),
                        child: Row(
                          children: [
                            GetBuilder<ProfileController>(
                                builder: (profileController) {
                              return Text(
                                "Hey,  ${profileController.model.data?.user?.firstname} ${profileController.model.data?.user?.lastname}",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              );
                            }),
                            const Spacer(),
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8)),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/filterscreen');
                                },
                                icon: SvgPicture.asset(
                                    "assets/images/filter.svg"),
                                label: const Text("Filter"),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            DateTimeRow(
              onRefresh: _refreshScreen,
            ),
            SizedBox(height: 28.h),
            // Use Obx to reactively rebuild the UI based on controller state
            Obx(() {
              final summaryController = Get.find<SalesSummaryController>();

              final leadsByStatusList =
                  summaryController.userStatus.value.data?.leadsByStatus ?? [];

              // Convert leadsByStatus list to a map for easy access
              // Convert leadsByStatus list to a map for easy access
              final leadsByStatusMap = {
                for (var lead in leadsByStatusList)
                  (lead.status ?? ''): lead.total ?? 0
              };
              return summaryController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Wrap(
                          spacing: 40.w,
                          runSpacing: 20.h,
                          alignment: WrapAlignment.center,
                          children: [
                            buildCircle(
                                summaryController
                                        .userStatus.value.data?.totalLeads
                                        .toString() ??
                                    '0',
                                'My Leads',
                                Colors.blue.shade900, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'all'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['login'] ?? 0).toString(),
                                'Login Leads',
                                Colors.teal, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'login'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['pending'] ?? 0)
                                    .toString(), // Handle null value here
                                'Pending Docs',
                                Colors.brown, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'pending'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['approved'] ?? 0)
                                    .toString(), // Handle null value here
                                'Approved',
                                Colors.purple, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'approved'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['agreementdone'] ?? 0)
                                    .toString(), // Handle null value here
                                'Agreement Done',
                                Colors.orange, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'agreementdone'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['disbursed'] ?? 0)
                                    .toString(), // Handle null value here
                                'Disbursed',
                                Colors.green, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'disbursed'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['expired'] ?? 0)
                                    .toString(), // Handle null value here
                                'Expired Leads',
                                Colors.yellow, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'expired'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['payoutreleased'] ?? 0)
                                    .toString(), // Handle null value here
                                'Payout Released',
                                Colors.green, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'payoutreleased'});
                            }),
                            buildCircle(
                                (leadsByStatusMap['rejected'] ?? 0)
                                    .toString(), // Handle null value here
                                'Rejected',
                                Colors.red, () {
                              Navigator.pushNamed(context, '/maindashscreen',
                                  arguments: {'status': 'rejected'});
                            }),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/leadsscreen');
                                },
                                icon: const Icon(Icons.add_circle_outline),
                                label: const Text('Add New Leads'),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 10.h),
                                  backgroundColor: const Color(0xFF1769E9),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            }),

            SizedBox(height: 20.h),
            GetBuilder<SalesSummaryController>(builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    buildAmountCard(
                        'Still Date Approved Amount',
                        '₹ ${controller.userStatus.value.data?.totalApprovedAmount}/-',
                        "assets/images/star.svg",
                        () {}),
                    SizedBox(height: 10.h),
                    buildAmountCard(
                        'Still Date Net Disbursed Amount',
                        '₹ ${controller.userStatus.value.data?.netDisbursedAmount}/-',
                        "assets/images/star.svg",
                        () {}),
                    SizedBox(height: 10.h),
                    buildAmountCard(
                      'Monthly Scorecard August 2024',
                      '0%',
                      "assets/images/medal.svg",
                      () {},
                    ),
                    SizedBox(height: 10.h),
                    buildAmountCard(
                      'My Earnings',
                      '${controller.userStatus.value.data?.rewardAmount}',
                      "assets/images/star.svg",
                      () {
                        Navigator.pushNamed(
                            context, '/mysalesearningdashboard');
                      },
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: 70.h,
              width: double.infinity,
              color: const Color(0xffE9F1FD),
              child: Row(
                children: [
                  Text(
                    "Performance Chart",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: const Color(0xFF1769E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 15.h),
                      child: const Text("MORE"),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.0.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.faqScreen2);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/faq.svg",
                            height: 30.h, width: 30.w),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Faq',
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                            Text(
                              'All your queries answer',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const Divider(color: Colors.grey),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/supportscreen');
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/live.svg",
                            height: 30.h, width: 30.w),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Support',
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                            Text(
                              'Reach out for any help',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class DateTimeRow extends StatefulWidget {
  final VoidCallback onRefresh;
  const DateTimeRow({
    super.key,
    required this.onRefresh,
  });

  @override
  _DateTimeRowState createState() => _DateTimeRowState();
}

class _DateTimeRowState extends State<DateTimeRow> {
  late Timer _timer;
  late String _currentDate;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => _updateDateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    setState(() {
      _currentDate = DateFormat('dd:MM:yyyy').format(DateTime.now());
      _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 8.w),
          Text(
            _currentDate,
            style: TextStyle(fontSize: 18.sp),
          ),
          SizedBox(width: 16.w),
          Text(
            _currentTime,
            style: TextStyle(fontSize: 18.sp),
          ),
          const Spacer(),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: widget.onRefresh,
            child: SvgPicture.asset("assets/images/sync.svg"),
          ),
        ],
      ),
    );
  }
}

Widget buildCircle(
    String count, String label, Color color, VoidCallback onTap) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80.h,
          width: 90.w,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4.w),
          ),
          child: Center(
            child: Text(
              count,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      SizedBox(height: 4.h),
      Text(label, style: TextStyle(fontSize: 14.sp)),
    ],
  );
}

Widget buildAmountCard(
    String title, String amount, String svgPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            svgPath,
            width: 52.w,
            height: 52.h,
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1769E9),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
