import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final List<Map<String, String>> faqItems = [
    {
      'question': 'When will I get my payment?',
      'answer':
          'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type'
    },
    {'question': 'How is payout calculated?', 'answer': ''},
    {'question': 'Why did my payment fail?', 'answer': ''},
    {
      'question':
          'Is there a minimum earnings amount required to get the payment?',
      'answer': ''
    },
    {'question': 'How do I withdraw my Finovel earnings?', 'answer': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                              context, '/allpartners'),
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
                    SizedBox(height: 40.h),
                    Text(
                      'Frequently Asked Questions',
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ExpansionTile(
                      iconColor: Colors.black54,
                      // backgroundColor: Colors.amber,
                      // collapsedBackgroundColor: Colors.red,
                      textColor: Colors.black,
                      // collapsedTextColor: Colors.green,
                      title: Text(
                        faqItems[index]['question']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0.r),
                          child: Text(faqItems[index]['answer']!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
