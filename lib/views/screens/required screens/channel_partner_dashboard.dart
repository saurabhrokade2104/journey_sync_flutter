import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/leads/channel_partner_dashboard_controller.dart';
import 'package:finovelapp/data/repo/auth/general_setting_repo.dart';
import 'package:finovelapp/data/repo/leads/channel_partner_dashboard_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChannelPartnerDashboardScreen extends StatefulWidget {
  const ChannelPartnerDashboardScreen({super.key});

  @override
  State<ChannelPartnerDashboardScreen> createState() => _ChannelPartnerDashboardScreenState();
}

class _ChannelPartnerDashboardScreenState extends State<ChannelPartnerDashboardScreen> {

     @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));

    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(ChannelPartnerDashboardRepo(apiClient: Get.find()));

    final controller = Get.put(ChannelPartnerDashboardController(channelPartnerDashboardRepo: Get.find()));




    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     controller.fetchPartnerDashboard();

    });
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
                    'assets/imgs/header_bg.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 350.h,
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
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 15.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                  const Text(
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
                      SizedBox(height: 10.h),
                      Text(
                        'Channel Partners Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
                  child: GetBuilder<ChannelPartnerDashboardController>(
                    builder: (controller) {


                      return  controller.isLoading.value ? const   Center(child: CircularProgressIndicator()) :  Column(
                        children: [
                          SizedBox(height: 140.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            height: 170.h,
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 6.w),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 14.w),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Earned Amount",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 30.w),
                                      Container(
                                          height: 40.h,
                                          width: 1.w,
                                          color: Colors.white30),
                                      SizedBox(width: 50.w),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${controller.partnerDashboardInfo.value.data?.rewardAmount}",
                                            style: TextStyle(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                      height: 1.h,
                                      width: double.infinity,
                                      color: Colors.white30),
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 20.w),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/paid.svg"),
                                          ],
                                        ),
                                        SizedBox(width: 20.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Paid",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${controller.partnerDashboardInfo.value.data?.rewardAmount}",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                        ),
                                        Container(
                                            height: 40.h,
                                            width: 1.w,
                                            color: Colors.white30),
                                        SizedBox(width: 30.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/pending.svg"),
                                          ],
                                        ),
                                        SizedBox(width: 15.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pending",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "₹ 0",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, '/allpartners');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1769E9),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 70.w, vertical: 15.h),
                    ),
                    child: Text("My All Partners",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ),
                  SvgPicture.asset(
                    "assets/images/channel.svg",
                    height: 250.h,
                    width: 250.w,
                  ),
                  Text(
                    "Congratulations",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "You have successfully earned from your referred partners. Make new referral and earn more!",
                    style: TextStyle(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 100.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboardscreen');
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18.sp),
                      backgroundColor: const Color(0xFF1769E9),
                      foregroundColor: MyColor.whiteColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.h,
                        child: Center(
                          child: Text(
                            "ADD NEW PARTNER",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
