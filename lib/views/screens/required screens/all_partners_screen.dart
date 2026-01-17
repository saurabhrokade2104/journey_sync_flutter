import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllPartnersScreen extends StatelessWidget {
  const AllPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                                        context, '/channelscreen'),
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
                              SizedBox(
                                height: 25.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 16.0.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "My All Partners",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/filterscreen');
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      child: Container(
                        height: 90.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 70.h,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: SvgPicture.asset(
                                    "assets/images/rupee.svg",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Earned Amount",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                Text(
                                  "₹ 0",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Earnings",
                          style: TextStyle(
                              fontSize: 22.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Column(
                    //   children: [
                    //     buildContainer("Vikas Yadav", "V", "1654", () {
                    //       Navigator.pushNamed(context, '/earningfrompartners');
                    //     }),
                    //     buildContainer("Radhika Gupta", "R", "0", () {}),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.0.h),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/faqscreen');
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
                        "FAQ LIST",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

Widget buildContainer(
    String name, String initial, String amount, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.0.h),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1769E9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Referral Earnings",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      "₹$amount",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1769E9),
                      ),
                    ),
                  ),
                  Text(
                    "Paid",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
