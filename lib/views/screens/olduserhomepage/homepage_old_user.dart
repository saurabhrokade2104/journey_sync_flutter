import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/views/screens/olduserhomepage/widgets/text_widget.dart';
import 'package:finovelapp/views/screens/olduserhomepage/widgets/tube_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/container_swiper.dart';

class HomePageOldUser extends StatefulWidget {
  const HomePageOldUser({super.key});

  @override
  State<HomePageOldUser> createState() => _HomePageOldUserState();
}

class _HomePageOldUserState extends State<HomePageOldUser> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            size: 26,
          ),
        ),
        title: const TextWidget(
          content: 'FINOVEL',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              size: 26,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              height: size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    content: 'Welcome Back',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const TextWidget(
                    content: 'Doing Great Abhishek',
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      children: [
                        //
                        // First Row Start YOUR LOAN AND ON TRACK
                        //

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextWidget(
                              content: 'YOUR LOAN',
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0, right: 8, top: 2, bottom: 2),
                                child: TextWidget(
                                  content: 'ON TRACK',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          ],
                        ),
                        //
                        // First Row ENDED YOUR LOAN AND ON TRACK
                        //
                        //
                        const Divider(
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    trackTextWidget(
                                        title: '₹4,76,749',
                                        subtitle: 'Loan Amount'),
                                    trackTextWidget(
                                        title: '₹16,749',
                                        subtitle: 'Total Repaid'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    trackTextWidget(
                                        title: '24', subtitle: 'Months Left'),
                                    trackTextWidget(
                                        title: '₹16,749',
                                        subtitle: 'Total Due'),
                                  ],
                                ),
                                const TubeProgressIndicator(
                                    amount: '',
                                    percentage: 26,
                                    taskName: 'Paid')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: size.height * 0.035,
                              width: size.width - 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                              ),
                              child: Center(
                                child: TextWidget(
                                  content: 'View Full Loan Details >',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //
            //
            // Container closed here and all the details regarding loans ends here and percentage section
            //
            //
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15),
              child: TextWidget(
                content: 'Exclusive loan offers for you',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 2, right: 15.0),
              child: TextWidget(
                content:
                    'keep making payment on time to enjoy more benefits on your loans',
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
            cardSwiper(context),
            const Divider(
              color: Colors.grey,
            ),
            //
            //
            //  UPCOMING EMI CONTAINER STARTS FROM HERE
            //
            //

            upcomingEmiWidget(size, context),
            //
            //
            // UPCOMING EMI CONTAINTER CLOSED
            //
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8),
              child: TextWidget(
                content: 'QUICK ACTIONS',
                fontSize: 16,
                color: Color.fromARGB(255, 9, 9, 9),
                fontWeight: FontWeight.w200,
              ),
            ),
            quickActionWidget(
              context: context,
              icon: Icons.currency_rupee_outlined,
              img: 'assets/icons/rupees_icon.png',
              title: 'Loan History',
              subtitle: 'All your loans ongoing,pending and completed',
            ),
            quickActionWidget(
              context: context,
              icon: Icons.currency_rupee_outlined,
              img: 'assets/icons/transaction_history_icon.png',
              title: 'Transaction History',
              subtitle: 'All your loans ongoing,pending and completed',
            ),
            quickActionWidget(
              context: context,
              icon: Icons.currency_rupee_outlined,
              img: 'assets/icons/faq_icon.png',
              title: 'FAQs',
              subtitle: 'All your loans ongoing,pending and completed',
            ),
            quickActionWidget(
              context: context,
              icon: Icons.currency_rupee_outlined,
              img: 'assets/icons/support_icon.png',
              title: 'Support',
              subtitle: 'All your loans ongoing,pending and completed',
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );
  }

  Padding upcomingEmiWidget(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        height: size.height * 0.22,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  content: 'UPCOMING EMI',
                  fontSize: 15,
                  color: Colors.black,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.withOpacity(0.2),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 8, top: 2, bottom: 2),
                    child: TextWidget(
                      content: '14 DAYS LEFT',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 177, 168, 86),
                    ),
                  ),
                )
              ],
            ),
            const TextWidget(
              content:
                  'Your emi will be autoupdate from your bank. To avoid late you can pay advance',
              fontSize: 12,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                trackTextWidget(title: '2 Sep 2024', subtitle: 'Due Date'),
                trackTextWidget(title: '2 Sep 2024', subtitle: 'EMI Amount'),
              ],
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {},
                child: const TextWidget(
                  content: '  PAY IN ADVANCE  ',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget trackTextWidget({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            content: title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          TextWidget(
            content: subtitle,
            fontSize: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget quickActionWidget({
    required BuildContext context,
    required IconData icon,
    required String img,
    required String title,
    required String subtitle,
  }) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Container(
        height: size.height * 0.086,
        decoration: BoxDecoration(
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  child: Image.asset(
                    img,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      content: title,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      content: subtitle,
                      // content: 'All your loans ongoing,pending and completed',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    CupertinoIcons.forward,
                    size: 25,
                    color: MyColor.primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
