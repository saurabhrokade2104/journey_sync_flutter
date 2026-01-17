import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ReferralSteps extends StatelessWidget {
  const ReferralSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                            onTap: () => Navigator.popAndPushNamed(
                                context, '/referralscreen'),
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
                      SizedBox(height: 40.h),
                      const Text(
                        'Steps to Earn Referral Payout',
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
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ReferralStepsData(
                        svgPath: 'assets/images/share.svg',
                        title: 'Share Link to Friends',
                        description:
                            'Tips: Share to groups and reach your cash rewards faster',
                      ),
                      SizedBox(height: 10.h),
                      const ReferralStepsData(
                        svgPath: 'assets/images/download.svg',
                        title:
                            'Invitee fills in their mobile number to download Finovel App',
                      ),
                      SizedBox(height: 10.h),
                      const ReferralStepsData(
                        svgPath: 'assets/images/new_user.svg',
                        title:
                            'Invitee signs up on Finovel App, claims the new user reward',
                      ),
                      SizedBox(height: 10.h),
                      const ReferralStepsData(
                        svgPath: 'assets/images/reward_points.svg',
                        title: 'Get your reward points',
                      ),
                      SizedBox(height: 10.h),
                      const ReferralStepsData(
                        svgPath: 'assets/images/badge.svg',
                        title:
                            'Get your extra rewards when invitee tops up airtime.',
                        isLastStep: true,
                      ),
                      SizedBox(height: 20.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'RULES',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                          ),
                          buildRuleItem(
                            title: 'Referral Points',
                            description:
                                'Users earn 100 points for each successful referral (when the referred user installs the application).',
                          ),
                          buildRuleItem(
                            title: 'Point Value',
                            description: '1 point = ₹0.25.',
                          ),
                          buildRuleItem(
                            title: 'Redemption Threshold',
                            description:
                                'Users can redeem points only when they have accumulated at least 1000 points.',
                          ),
                          buildRuleItem(
                            title: 'Application Referral',
                            description:
                                'Tracking if the referral was successful in the application installation.',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h), // Add bottom padding
          ],
        ),
      ),
    );
  }
}

class ReferralStepsData extends StatelessWidget {
  final String svgPath;
  final String title;
  final String? description;
  final bool isLastStep;

  const ReferralStepsData(
      {super.key,
      required this.svgPath,
      required this.title,
      this.description,
      this.isLastStep = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 30.w,
              height: 30.h,
              colorFilter:
                  const ColorFilter.mode(Color(0xFF1769E9), BlendMode.srcIn),
            ),
            if (!isLastStep)
              Container(
                height: 40.h,
                width: 2.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0),
                      Colors.blue,
                      Colors.blue.withOpacity(0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              if (description != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.0.h),
                  child: Text(
                    description!,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildRuleItem({required String title, required String description}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('•', style: TextStyle(fontSize: 18.sp)),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
