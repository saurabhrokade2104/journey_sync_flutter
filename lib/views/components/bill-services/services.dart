import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/notifications/notification_controller.dart';
import 'package:finovelapp/views/components/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  int pageNo = 0;
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    // Provider.of<HomeProvider>(context, listen: false).getHomeData();
  }

  void showComingSoonDialog() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Coming Soon'),
    //       content: const Text('This feature is coming soon'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     );
    //   },
    // );
    Get.snackbar(
      "Coming Soon!", // Title
      "This feature is under development and will be available soon.", // Message
      snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
      backgroundColor: AppColors.accentColor, // Background color
      colorText: Colors.white, // Text color
      duration: const Duration(seconds: 1), // Duration of the snackbar
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Image.asset(
                'assets/imgs/header_bg.png',
                fit: BoxFit.fill,
                width: double.infinity,
                height: 170,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 42),
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'FINOVEL',
                        style: TextStyle(
                          color: MyColor.whiteColor,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'TitilliumWeb',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        print('tapped notification icon');
                        Get.toNamed(RouteHelper.notificationScreen);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: MyColor.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 73),
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontFamily: 'SourceSans3',
                          fontSize: 22,
                          color: MyColor.whiteColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 4, bottom: 3),
                      child: Text(
                        'Manage your payments and recharges effortlessly!',
                        style: TextStyle(fontSize: 14, color: MyColor.greyColor),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 180),
                 Section(
                    title: "Quick Actions",
                    items: [
                      SectionItem('Mobile', 'assets/icons/bill/postpad_mobile.svg'),
                      SectionItem('DTH', 'assets/icons/bill/dth.svg'),
                      SectionItem('LPG', 'assets/icons/bill/cylinder.svg'),
                      SectionItem('Electricity', 'assets/icons/bill/bulb.svg'),
                    ],
                  ),
                  Section(
                    title: "Recharge",
                    items: [
                      SectionItem('Mobile', 'assets/icons/bill/postpad_mobile.svg'),
                      SectionItem('DTH', 'assets/icons/bill/dth.svg'),
                      SectionItem('Google Play', 'assets/icons/bill/google_play.svg'),
                      SectionItem('Fastag', 'assets/icons/bill/fastag.png', isSvgImage: false,),
                      SectionItem('Metro', 'assets/icons/bill/metro.svg'),
                      SectionItem('Fastag Apply', 'assets/icons/bill/fastag.png',isSvgImage: false,),
                    ],
                  ),
                  Section(
                    title: "Pay Bills",
                    items: [
                      SectionItem('Electricity', 'assets/icons/bill/bulb.svg'),
                      SectionItem('Gas Cylinder', 'assets/icons/bill/cylinder.svg'),
                      SectionItem('Credit Card', 'assets/icons/bill/credit_card_blue.svg'),
                      SectionItem('Rent Pay', 'assets/icons/bill/rent.svg'),
                      SectionItem('Broadband', 'assets/icons/bill/broadband.svg'),
                      SectionItem('Piped Gas', 'assets/icons/bill/pipeline.svg'),
                      SectionItem('Loan Repayment', 'assets/icons/bill/loan_repayment.svg'),
                      SectionItem('Society Maintenance', 'assets/icons/bill/society_maintenance.svg'),
                      SectionItem('Municipal Tax', 'assets/icons/bill/tax.svg'),
                      SectionItem('Landline Postpaid', 'assets/icons/bill/telephone.svg'),
                      SectionItem('Education Fees', 'assets/icons/bill/education_fees.svg'),
                      SectionItem('Cable TV', 'assets/icons/bill/tv.svg'),
                      SectionItem('Hospital', 'assets/icons/bill/hospital.svg'),
                      SectionItem('Mobile Postpaid', 'assets/icons/bill/postpad_mobile.svg'),
                      SectionItem('Club and Association', 'assets/icons/bill/club.svg'),
                      SectionItem('Water', 'assets/icons/bill/water_drop.svg'),
                    ],
                  ),
                  Section(
                    title: "Insurance",
                    items: [
                      SectionItem('Health', 'assets/icons/bill/health.svg'),
                      SectionItem('Bike', 'assets/icons/bill/bike.svg'),
                      SectionItem('Car', 'assets/icons/bill/car.png',isSvgImage: false,),
                      SectionItem('Term Insurance', 'assets/icons/bill/term_insurance.svg'),
                      SectionItem('Life Insurance', 'assets/icons/bill/life_insurance.svg'),
                      SectionItem('Commercial Vehicle', 'assets/icons/bill/commercial.svg'),
                    ],
                  ),
                  Section(
                    title: "Investments",
                    items: [
                      SectionItem('Digital Gold', 'assets/icons/bill/gold.svg'),
                      SectionItem('Fixed Deposit', 'assets/icons/bill/fixed_deposit.svg'),
                      SectionItem('Mutual Funds', 'assets/icons/bill/mutual_funds.svg'),
                      SectionItem('Recurring Deposit', 'assets/icons/bill/recurring_deposit.svg'),
                      SectionItem('Bonds', 'assets/icons/bill/bonds.svg'),
                      SectionItem('SDI', 'assets/icons/bill/sdi.svg'),
                      SectionItem('More Investments', 'assets/icons/bill/more_investments.svg'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Upcoming Payments',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: Column(
                      children: [
                        InkWell(
                          child: ListTile(
                            title: const Text(
                              'Electricity Bill',
                              style: TextStyle(
                                fontFamily: 'SourceSans3',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5645134848484',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'SourceSans3',
                                  ),
                                ),
                                Text(
                                  'Due Date 10 Oct',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'SourceSans3',
                                  ),
                                ),
                              ],
                            ),
                            leading: Image.asset(
                              'assets/imgs/ec_bill.png',
                              height: 40,
                            ),
                            trailing: Container(
                              height: 35,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.secondoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () => {},
                                child: const Text(
                                  'Pay Now',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0, left: 10),
                          child: Divider(),
                        ),
                        ListTile(
                          title: const Text(
                            'Water Bill',
                            style: TextStyle(
                              fontFamily: 'SourceSans3',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '5645134848484',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'SourceSans3',
                                ),
                              ),
                              Text(
                                'Due Date 10 Oct',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'SourceSans3',
                                ),
                              ),
                            ],
                          ),
                          leading: Image.asset(
                            'assets/imgs/watbill.png',
                            height: 40,
                          ),
                          trailing: Container(
                            height: 35,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.secondoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () => {},
                              child: const Text(
                                'Pay Now',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0, left: 10),
                          child: Divider(),
                        ),
                        ListTile(
                          title: const Text(
                            'Electricity Bill',
                            style: TextStyle(
                              fontFamily: 'SourceSans3',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '5645134848484',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'SourceSans3',
                                ),
                              ),
                              Text(
                                'Due Date 10 Oct',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'SourceSans3',
                                ),
                              ),
                            ],
                          ),
                          leading: Image.asset(
                            'assets/imgs/ec_bill.png',
                            height: 40,
                          ),
                          trailing: Container(
                            height: 35,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.secondoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () => {},
                              child: const Text(
                                'Pay Now',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
    }
class Section extends StatefulWidget {
  final String title;
  final List<SectionItem> items;

  const Section({super.key, required this.title, required this.items});

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    int itemCount = isExpanded ? widget.items.length : 4;
    List<SectionItem> visibleItems = widget.items.take(itemCount).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (widget.items.length > 4)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? "See less" : "See more",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: visibleItems,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class SectionItem extends StatelessWidget {
  final String label;
  final String image;
  final bool showPayNow;
  final bool isSvgImage;

  const SectionItem(this.label,  this.image, {super.key, this.showPayNow = false,this.isSvgImage=true});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth / 4 - 09;

        return SizedBox(
          width: itemWidth,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle item tap
                },
                child: Column(
                  children: [
                   isSvgImage ? SvgPicture.asset(image, height: 35) : Image.asset(image, height: 35,),
                   const  SizedBox(height: 8),
                    Text(label, textAlign: TextAlign.center),
                  ],
                ),
              ),
              if (showPayNow)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Pay Now"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}