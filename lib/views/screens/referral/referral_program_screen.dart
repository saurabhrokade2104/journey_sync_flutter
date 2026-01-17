import 'package:dotted_border/dotted_border.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/my_color.dart';
// import 'package:finovelapp/views/components/appbar/custom_appbar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

class ReferralProgramScreen extends StatelessWidget {
  const ReferralProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/imgs/header_bg.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: 388.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 42.h, left: 20.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
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
                    child: Image.asset(
                      "assets/imgs/notification.png",
                      height: 40.h,
                      width: 40.w,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      children: [
                        Text(
                          'Refer your friends and partners',
                          style: TextStyle(
                              fontSize: 20.sp, color: MyColor.whiteColor),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text.rich(
                          const TextSpan(children: [
                            TextSpan(text: 'Earn'),
                            TextSpan(
                              text: ' 100 points',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' for each successful referral'),
                          ]),
                          style: TextStyle(
                            fontSize: 26.sp,
                            color: MyColor.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/referral_people.svg',
                    height: 200.h,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Your referral code',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Padding(
                      
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 70.w),
                      child: DottedBorder(
                        // padding: EdgeInsets.only(top: 5, bottom: 5, left: 70.w),
                        // color: Colors.black26,
                        // strokeWidth: 1,
                        child: Row(
                          children: [
                            const Spacer(),
                            const Text(
                              'John18233',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 90.w),
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Container(
                                  height: 70.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/images/copy.svg",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share, size: 24.sp),
                        label: Text(
                          'SHARE LINK',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 18.h),
                          textStyle: const TextStyle(fontSize: 18),
                          backgroundColor: const Color(0xFF1769E9),
                          foregroundColor: MyColor.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xffE8F0FD),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                bottom: 20.h,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // First Column
                                  Row(
                                    children: [
                                      Container(
                                        height: 60.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/referred.svg',
                                          height: 24.h,
                                          width: 24.w,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      SizedBox(width: 8.h),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Total App Referred',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '10',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Vertical Divider
                                  Container(
                                    height: 60.h,
                                    width: 1.w,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  // Second Column
                                  Row(
                                    children: [
                                      Container(
                                        height: 60.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/My_partners.svg',
                                          height: 24.h,
                                          width: 24.w,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'My Partners',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '02',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/referralsteps');
                              },
                              child: Container(
                                height: 60.h,
                                width: double.infinity,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/rupee.svg"),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Steps to Earn Referral Payout',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.shade700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/tncscreen');
                              },
                              child: Container(
                                height: 60.h,
                                width: double.infinity,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/term.svg"),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Terms & Conditions',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.shade700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/dashboardscreen');
                              },
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 18.sp),
                                backgroundColor: const Color(0xFF1769E9),
                                foregroundColor: MyColor.whiteColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0.w),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 40.h,
                                  child: Center(
                                    child: Text(
                                      "DASHBOARD",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
