import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
                                context, '/referralscreen'),
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
                      SizedBox(height: 30.h),
                      Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8.r)),
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.0.w, vertical: 18.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. Applications Referral Program",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),
                      buildTermsItem(
                          title: "Referral Points: ",
                          description:
                              "User earn 100 points for each successsful referral(when the referred user installs the application)."),
                      const Divider(thickness: 1),
                      buildTermsItem(
                          title: "Point Value: ",
                          description: "1 point = ₹0.25"),
                      const Divider(thickness: 1),
                      buildTermsItem(
                          title: "Redemption Threshold: ",
                          description:
                              "Users can redeem points only when they have accumulated at least 1000 points."),
                      const Divider(thickness: 1),
                      SizedBox(height: 12.h),
                      const Text(
                        "2. Product Referral Earning Program",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),
                      buildTermsItem(
                          title: "Application Referral: ",
                          description:
                              "Tracking if the referral was sucesssful in the application installation."),
                      const Divider(thickness: 1),
                      buildTermsItem(
                          title: "Type of Product Referral: ",
                          description:
                              "Identifying the specific product being referred (e.g., personal loans, credit cards, insurance)."),
                      const Divider(thickness: 1),
                      SizedBox(height: 12.h),
                      const Text(
                        "3. Earnings:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),
                      buildTermsItem(
                          title: "",
                          description:
                              "Based on the predefined values for each product referral, the earned amount will be credited to the user's wallet account."),
                      buildTermsItem(
                          title: "",
                          description:
                              "Wallet to bank account money transfer option will be available, allowing users to easily transfer their earnings from the wallet to thier bank account once eligible."),
                      const Divider(thickness: 1),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildTermsItem({required String title, required String description}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('•', style: TextStyle(fontSize: 14.sp)),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: description,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
