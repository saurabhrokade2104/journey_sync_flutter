import 'package:carousel_slider/carousel_slider.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/util.dart';
import 'package:finovelapp/credit_history.dart';
import 'package:finovelapp/data/controller/notifications/notification_controller.dart';
import 'package:finovelapp/data/model/loan/loan_offer.dart';
import 'package:finovelapp/data/model/loan/running_loan_response.dart';
import 'package:finovelapp/data/repo/notification_repo/notification_repo.dart';
import 'package:finovelapp/views/components/bill-services/services.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:finovelapp/views/components/drawer/drawer.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';
import 'package:finovelapp/views/screens/account/profile/my_profile_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bigloan/big_loan_screen.dart';

// import 'package:finovelapp/views/screens/auth/kyc/kyc.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/transaction/transaction_screen_new.dart';
import 'package:finovelapp/views/screens/olduserhomepage/widgets/text_widget.dart';
import 'package:finovelapp/views/screens/olduserhomepage/widgets/tube_progress_indicator.dart';
import 'package:finovelapp/views/screens/referral/referral_application_status_screen.dart';
import 'package:finovelapp/views/screens/referral/referral_program_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/route/route.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../data/controller/account/profile_controller.dart';
import '../../../../data/controller/home/home_controller.dart';
import '../../../../data/controller/loan/loan_plan_controller.dart';
import '../../../../data/repo/account/profile_repo.dart';
import '../../../../data/repo/auth/general_setting_repo.dart';
import '../../../../data/repo/home/home_repo.dart';
import '../../../../data/repo/loan/loan_repo.dart';
import '../../../../data/services/api_service.dart';

import '../../kyc/bank_details.dart';

import 'package:finovelapp/data/controller/menu_/menu_controller.dart' as menu;

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CreditHistory(),
    ServicesScreen(),
    const TransactionScreenNew(),
    const MyProfileScreen(),
  ];

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoanRepo(apiClient: Get.find()));

    Get.put(HomeRepo(apiClient: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    final planController = Get.put(LoanPlanController(loanRepo: Get.find()));
    final controller = Get.put(HomeController(repo: Get.find()));
    final menuController = Get.put(menu.MenuController(repo: Get.find()));

    Get.put(ProfileRepo(
      apiClient: Get.find(),
    ));
    Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
      planController.loadLoanPlan();
      menuController.loadData();
      Get.find<ProfileController>().loadProfileInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: drawerWidget(context),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed, // Set to fixed
          currentIndex: _currentIndex,
          selectedIconTheme: const IconThemeData(color: MyColor.primaryColor),
          showUnselectedLabels: true,
          unselectedItemColor: MyColor.colorBlack,
          unselectedIconTheme: const IconThemeData(color: MyColor.colorBlack),
          selectedFontSize: 11,
          unselectedLabelStyle: const TextStyle(
              height: 2.5,
              fontFamily: 'SourceSans3',
              fontWeight: FontWeight.w500),
          selectedLabelStyle: const TextStyle(
              height: 2.5,
              fontFamily: 'SourceSans3',
              color: MyColor.primaryColor,
              fontWeight: FontWeight.w500),
          unselectedFontSize: 11,
          selectedItemColor: MyColor.primaryColor,
          onTap: (value) => {
                setState(
                  () => _currentIndex = value,
                )
              },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/imgs/credit_nav.png',
                height: 20,
                color: (_currentIndex == 1)
                    ? MyColor.accentColor
                    : MyColor.blackColor,
              ),
              label: 'CREDIT',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/imgs/services_nav.png',
                  height: 20,
                  color: (_currentIndex == 2)
                      ? MyColor.accentColor
                      : MyColor.blackColor),
              label: 'ALL SERVICES',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/imgs/history_nav.png',
                  height: 20,
                  color: (_currentIndex == 3)
                      ? MyColor.accentColor
                      : MyColor.blackColor),
              label: 'HISTORY',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/imgs/more_nav.png',
                color: (_currentIndex == 4)
                    ? MyColor.accentColor
                    : MyColor.blackColor,
                height: 20,
              ),
              label: 'MORE',
            ),
          ]),
      body: _pages[_currentIndex],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  // int pageNo = 0;
  int _selectedOfferIndex = 0;

  final List<LoanOffer> loanOffers = [
    LoanOffer(
      title: 'Loan On Salary',
      subtitle: 'In 15 Minutes',
      description: 'To withdraw and get more loan amount complete your KYC',
      imageUrl: 'assets/imgs/money_img.png',
      label: 'GET UP TO ₹ 50,000',
    ),
    // Add more LoanOffer objects as needed
  ];

  final List<LoanOffer> loanOffers2 = [
    LoanOffer(
      title: 'Loan On Salary',
      subtitle: 'In 15 Minutes',
      description: 'To withdraw and get more loan amount complete your KYC',
      imageUrl:
          'assets/images/incred_logo.png', // Update with the actual image path
      label: 'Get up to ₹5 Lakh',
    ),
    LoanOffer(
      title: 'Loan On Salary',
      subtitle: 'In 15 Minutes',
      description: 'To withdraw and get more loan amount complete your KYC',
      imageUrl:
          'assets/images/aditya_birla_logo.png', // Update with the actual image path
      label: 'Get up to ₹5 Lakh',
    ),
  ];
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(NotificationRepo(apiClient: Get.find()));
    final controller = Get.put(NotificationsController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.page = 0;
      controller.clickIndex = -1;
      controller.initData();
      // scrollController.addListener(scrollListener);
    });
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onLoanOfferCardSwipe(int index, CarouselPageChangedReason reason) {
    setState(() {
      _selectedOfferIndex = index;
    });
  }

  Future<void> _refreshData() async {
// call homecontroller loaddata
    Get.find<HomeController>().loadData();
    Get.find<NotificationsController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      body: _buildAndroidRefreshControl(context),
    );
  }

  Widget _buildAndroidRefreshControl(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: MyColor.accentColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildPageContent(context),
      ),
    );
  }

  Widget _buildIOSRefreshControl(BuildContext context) {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: _refreshData,
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 60.0,
        ),
        SliverToBoxAdapter(
          child: _buildPageContent(context),
        ),
      ],
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/imgs/header_bg.png',
        fit: BoxFit.fill,
        width: double.infinity,
        height: 385,
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
                    fontSize: 18),
              ),
            ),
            const Spacer(),
            GetBuilder<NotificationsController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    print('tapped notification icon');
                    Get.toNamed(RouteHelper.notificationScreen);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.notifications_outlined,
                      // Use controller method to check for unread notifications
                      color: controller.hasUnreadNotifications()
                          ? Colors.red
                          : MyColor.whiteColor,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      GetBuilder<HomeController>(builder: (controller) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 73),
                child: Text(
                  'Hello, Welcome ${controller.firstName}',
                  style: const TextStyle(
                      fontFamily: 'SourceSans3',
                      fontSize: 22,
                      color: MyColor.whiteColor),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 4, bottom: 3),
                child: Text(
                  'Fast money for your daily expenses.',
                  style: TextStyle(fontSize: 14, color: MyColor.greyColor),
                ),
              ),
              GetBuilder<HomeController>(
                  builder: (homeController) => Container(
                        width: MediaQuery.sizeOf(context).width,
                        // height: 500,
                        decoration: BoxDecoration(
                          color: MyColor.transparentColor,
                        ),

                        child: GetBuilder<LoanPlanController>(
                          builder: (controller) {
                            return controller.isLoading
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  )

                                // : loanCardWidget( loanTitle: controller.planList[0].title!);
                                : GetBuilder<HomeController>(
                                    builder: (controller) {
                                    debugPrint(
                                        'running loan status ${controller.runningLoanStatus.value}');
                                    switch (
                                        controller.runningLoanStatus.value) {
                                      case true:
                                        return Column(
                                          children: [
                                            RunningCreditLineWidget(
                                              onPageChanged: _onPageChanged,
                                              initialIndex: _currentIndex,
                                            ),
                                            const ResponsiveTransferCardWidget(),
                                          ],
                                        );
                                      case false:
                                        return loanCardWidget(
                                            loanTitle: 'Loan On Salary',
                                            controller: controller);
                                      default:
                                        return loanCardWidget(
                                            loanTitle: 'Loan On Salary',
                                            controller: controller);
                                    }
                                  });
                          },
                        ),
                      )),
              const SizedBox(
                height: 30,
              ),

                       GetBuilder<HomeController>(builder: (controller) {
                return controller.runningLoanStatus.value
                    ? upcomingEmiWidget(context)
                    : const SizedBox.shrink();
              }),

                const SizedBox(height: 30,),

              ResponsiveLoanOffersWidget(
                  onOfferTap: _onLoanOfferCardSwipe,
                  pageNo: _selectedOfferIndex,
                  loanOffers: loanOffers,
                  isSvgImage: false),

              const SizedBox(height: 20),
              // _buildThirdPartyProductsSection(),

              //  const SizedBox(height: 20),

              // ResponsiveLoanOffersWidget(onOfferTap:  _onLoanOfferCardSwipe, pageNo: _selectedOfferIndex,loanOffers: loanOffers2,isShowTitles: false,isSvgImage: false),

              GetBuilder<HomeController>(builder: (controller) {
                return buildVerificationSection(context, controller);
              }),

              const SizedBox(height: 10),
              _buildReferAndEarnSection(),

              const SizedBox(
                height: 25,
              ),

              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'QUICK ACTIONS',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => {
                        Get.toNamed(RouteHelper.myLoanScreen, arguments: 'list')
                      },
                      child: ListTile(
                        title: const Text('Loan History',
                            style: TextStyle(
                                fontFamily: 'SourceSans3',
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                        subtitle: const Text(
                          'All your Loans Ongoing, Pending & Completed',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'SourceSans3',
                          ),
                        ),
                        leading: Image.asset(
                          'assets/imgs/loan_history.png',
                          height: 40,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: MyColor.secondoryColor1,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      title: const Text('Transaction History',
                          style: TextStyle(
                              fontFamily: 'SourceSans3',
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                      subtitle: const Text('Home for your all Transactions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'SourceSans3',
                          )),
                      leading: Image.asset(
                        'assets/imgs/trans_history.png',
                        height: 40,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: MyColor.secondoryColor1,
                      ),
                      onTap: () {
                        Get.toNamed(RouteHelper.transactionScreen);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed(RouteHelper.faqScreen);
                      },
                      title: const Text('Faq',
                          style: TextStyle(
                              fontFamily: 'SourceSans3',
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                      subtitle: const Text('all your queries answer',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SourceSans3',
                            color: Colors.black,
                          )),
                      leading: Image.asset(
                        'assets/imgs/faq_icon.png',
                        height: 40,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: MyColor.secondoryColor1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed(RouteHelper.faqScreen);
                      },
                      title: const Text('Support',
                          style: TextStyle(
                              fontFamily: 'SourceSans3',
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                      subtitle: const Text('Reach out for any help',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'SourceSans3',
                          )),
                      leading: Image.asset(
                        'assets/imgs/support_icon.png',
                        height: 40,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: MyColor.secondoryColor1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              knowCreditScore(),
              const SizedBox(height: 12),
              securityTag(),

              const SizedBox(height: 15),
              bottomWidget(),
            ],
          ),
        );
      })
    ]);
  }

  Widget securityTag() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/security.png', width: 24),
            const SizedBox(
                width: 8), // Provides space between the icon and the text
            const Flexible(
              // Makes the text wrap if the screen is too narrow
              child: Text(
                'Your data is 100% safe & secure',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16, // You can adjust the font size here
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(
            height: 8), // Provides space between the text and the check mark
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Proudly made in India ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // You can adjust the font size here
              ),
            ),
            Image.asset('assets/images/india_flag.png', width: 24),
          ],
        ),

        const Divider(
          color: Colors.grey,
          // thickness: 1.5,
        ),
      ],
    );
  }
}

Widget knowCreditScore() {
  return GestureDetector(
    onTap: () {
      Get.toNamed(RouteHelper.creditScoreScreen,
          arguments: ['5000', 850, false]);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      margin: const EdgeInsets.all(15),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Image.asset(
              'assets/icons/credit_score_icon.png',
              height: 80,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          const TextWidget(
            content: 'KNOW YOUR \nCREDIT SCORE',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    ),
  );
}

Padding loanCardWidget(
    {required String loanTitle, required HomeController controller}) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 13.0, left: 16.0, right: 16, bottom: 10),
    child: Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 7, right: 0),
      decoration: BoxDecoration(
          color: MyColor.whiteColor,
          borderRadius: BorderRadius.circular(12.00)),
      height: 197,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 0),
            child: Text(
              'YOUR LOAN',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'SourceSans3',
                color: Colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              right: 15.0,
              left: 8.0,
            ),
            child: Divider(
              thickness: 1,
            ),
          ),
          Stack(
            children: [
              const FractionallySizedBox(
                  widthFactor: 0.6, // 60% width

                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 54),
                    child: Text(
                      'To withdraw and get more loan amount complete your KYC',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'SourceSans3',
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              const FractionallySizedBox(
                  widthFactor: 0.8, // 60% width

                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 1),
                    child: Text(
                      'Get loan as per your credit score within 5 Minutes',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SourceSans3',
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, right: 10),
                    child: Image.asset(
                      'assets/imgs/header_logo.png',
                      height: 103,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 96),
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        backgroundColor: MyColor.primaryColor),
                    onPressed: () {
                      controller.canCheckEligibility();
                    },
                    child: const Text(
                      'APPLY FOR LOAN',
                      style: TextStyle(
                          fontFamily: 'SourceSans3',
                          fontSize: 14,
                          color: MyColor.whiteColor,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          )
        ],
      ),
    ),
  );
}

Padding eligibleAmountWidget(
    {required String loanTitle, required HomeController controller}) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 13.0, left: 16.0, right: 16, bottom: 10),
    child: Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 7, right: 0),
      decoration: BoxDecoration(
          color: MyColor.whiteColor,
          borderRadius: BorderRadius.circular(12.00)),
      height: 197,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 0),
            child: Text(
              'YOUR LOAN',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'SourceSans3',
                color: Colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              right: 15.0,
              left: 8.0,
            ),
            child: Divider(
              thickness: 1,
            ),
          ),
          Stack(
            children: [
              const FractionallySizedBox(
                  widthFactor: 0.6, // 60% width

                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 34),
                    child: Text(
                      'As per credit score you can get above amount',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'SourceSans3',
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              const FractionallySizedBox(
                  widthFactor: 0.8, // 60% width

                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 1),
                    child: Text(
                      'up to ₹16,749 loan amount',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SourceSans3',
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, right: 10),
                    child: Image.asset(
                      'assets/imgs/header_logo.png',
                      height: 103,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 76),
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        backgroundColor: MyColor.primaryColor),
                    onPressed: () {
                      controller.canCheckEligibility();
                    },
                    child: const Text(
                      'Take Loan',
                      style: TextStyle(
                          fontFamily: 'SourceSans3',
                          fontSize: 14,
                          color: MyColor.whiteColor,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          )
        ],
      ),
    ),
  );
}

Padding loanCardEmiWidget(
    {required String loanTitle,
    required HomeController controller,
    required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  return Padding(
    padding:
        const EdgeInsets.only(top: 13.0, left: 16.0, right: 16, bottom: 10),
    child: Container(
      padding: const EdgeInsets.all(12.0),
      height: size.height * 0.23,
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
                  color: AppColors.accentColor.withOpacity(0.2),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 8.0, right: 8, top: 2, bottom: 2),
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
                          title: '₹4,76,749', subtitle: 'Loan Amount'),
                      trackTextWidget(
                          title: '₹16,749', subtitle: 'Total Repaid'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      trackTextWidget(title: '24', subtitle: 'Months Left'),
                      trackTextWidget(title: '₹16,749', subtitle: 'Total Due'),
                    ],
                  ),
                  const TubeProgressIndicator(
                      amount: '', percentage: 26, taskName: 'Paid')
                  //                   CircularPercentIndicator(
                  //   radius: 55.0,
                  //   animation: true,
                  //   animationDuration: 1200,
                  //   lineWidth: 15.0,
                  //   percent: 0.4,
                  //   center: new Text(
                  //     "40%\nPaid",
                  //     style:
                  //         new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  //   ),
                  //   circularStrokeCap: CircularStrokeCap.butt,
                  //   backgroundColor: Colors.yellow,
                  //   progressColor: Colors.green,
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.035,
                width: size.width - 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
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
  );
}

Widget _buildThirdPartyProductsSection() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: MyColor.whiteColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3rd Party Products',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColor.blackColor,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3; // Default value for larger screens
            double width = constraints.maxWidth;

            if (width <= 600) {
              crossAxisCount = 3; // Smaller screens
            }

            return SizedBox(
              height: (constraints.maxWidth / crossAxisCount * 0.9) * 3 +
                  (16 * 2) +
                  (12 * 12),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 18,
                childAspectRatio:
                    0.8, // Adjust the aspect ratio to ensure proper height
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildProductItem('Personal Loan', 'upto 6%',
                      'assets/icons/personal_loan.svg'),
                  _buildProductItem('Business Loan', 'upto 2.1%',
                      'assets/icons/business_loan.svg'),
                  _buildProductItem('Credit Line', 'upto ₹1400',
                      'assets/icons/credit_line.svg'),
                  _buildProductItem('Credit Card', 'upto ₹3500',
                      'assets/icons/credit_card.svg'),
                  _buildProductItem('Investment', 'upto ₹1200',
                      'assets/icons/investment.svg'),
                  _buildProductItem('Demat A/c', 'upto ₹1150',
                      'assets/icons/demat_account.svg'),
                  _buildProductItem('Saving A/c', 'upto ₹1300',
                      'assets/icons/saving_account.svg'),
                  _buildProductItem(
                      'Insurance', '', 'assets/icons/insurance.svg'),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildProductItem(String title, String subtitle, String iconPath) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xffE8F0FD),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            height: 40,
          ),
        ),
      ),
      const SizedBox(height: 7),
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      if (subtitle.isNotEmpty)
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: MyColor.accentColor,
          ),
          textAlign: TextAlign.center,
        ),
    ],
  );
}

Widget _buildReferAndEarnSection() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: MyColor.whiteColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Refer & Earn',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColor.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Invite your friends, partners & earn rewards points.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Refer now action
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    backgroundColor: MyColor.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text('Refer Now'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: SvgPicture.asset(
            'assets/icons/refer_earn.svg', // Replace with the correct asset path
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}

Widget bottomWidget() {
  return Container(
    child: Image.asset(
      'assets/images/india.png', // Replace with the correct asset path
      fit: BoxFit.cover,
    ),
  );
}

Widget upcomingEmiWidget(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    padding: const EdgeInsets.all(20.0),
    margin: const EdgeInsets.only(top: 08, left: 20, right: 20),
    height: 200,
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
            trackTextWidget(title: '14 October  2024', subtitle: 'Due Date'),
            trackTextWidget(title: '₹ 110/-', subtitle: 'EMI Amount'),
          ],
        ),
        Container(
          height: 35,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {
              Get.toNamed(RouteHelper.newDepositScreenScreen);
            },
            child: const TextWidget(
              content: '  PAY IN ADVANCE  ',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget creditLineSwiper(BuildContext context, RunningLoanModel loan) {
  // Parse and format the credit line and transferred amounts
  final double creditLineAmount = double.tryParse(loan.amount ?? "0") ?? 0.0;
  final double transferredAmount =
      double.tryParse(loan.transferredAmount ?? "0") ?? 0.0;

  // Calculate the available limit, ensuring it doesn't go below zero
  final double availableLimit =
      (creditLineAmount - transferredAmount).clamp(0.0, creditLineAmount);

  // Format the amounts for display
  final String formattedCreditLineAmount =
      MyUtil.formatAmount(creditLineAmount.toString());
  final String formattedTransferredAmount =
      MyUtil.formatAmount(transferredAmount.toString());
  final String formattedAvailableLimit =
      MyUtil.formatAmount(availableLimit.toString());

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            content: 'Finovel CreditLine',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 11,
          ),
          Divider(
            height: 2,
            thickness: 0.8,
            color: Colors.grey,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      fontSize: 18,
                      content: 'Total CreditLine Limit',
                      color: Colors.grey,
                    ),
                    TextWidget(
                      fontSize: 22,
                      content: '₹$formattedCreditLineAmount/-',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                upDownTextWidgetCreditLine(
                  title: 'Outstanding',
                  subtitle: '₹$formattedTransferredAmount/-',
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(),
              child: TubeProgressIndicator(
                amount: '₹$formattedAvailableLimit/-',
                percentage: availableLimit / creditLineAmount * 100,
                taskName: 'Available limit',
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget creditLineSwiper2(BuildContext context, RunningLoanModel loan) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            content: 'Finovel CreditLine',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 11,
          ),
          Divider(
            height: 2,
            thickness: 0.8,
            color: Colors.grey,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                upDownTextWidgetCreditLine(
                  title: 'Total CreditLine Limit',
                  subtitle: '₹25,000/-',
                ),
                const SizedBox(
                  height: 10,
                ),
                upDownTextWidgetCreditLine(
                  title: 'Paid Amount',
                  subtitle: '₹0/-',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: upDownTextWidgetCreditLine(
              title: 'Available limit',
              subtitle: '₹25,000/-',
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(),
              child: const TubeProgressIndicator(
                  amount: '₹25,000/-',
                  percentage: 25,
                  taskName: 'Available limit'),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget creditLineSwiper3(BuildContext context, RunningLoanModel loan) {
  // Parse and format the credit line and transferred amounts
  final double creditLineAmount = double.tryParse(loan.amount ?? "0") ?? 0.0;
  final double transferredAmount =
      double.tryParse(loan.transferredAmount ?? "0") ?? 0.0;

  // Calculate the available limit, ensuring it doesn't go below zero
  final double availableLimit =
      (creditLineAmount - transferredAmount).clamp(0.0, creditLineAmount);

  // Format the amounts for display
  final String formattedCreditLineAmount =
      MyUtil.formatAmount(creditLineAmount.toString());
  final String formattedTransferredAmount =
      MyUtil.formatAmount(transferredAmount.toString());
  final String formattedAvailableLimit =
      MyUtil.formatAmount(availableLimit.toString());

  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                content: 'Finovel CreditLine',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 11,
              ),
              Divider(
                height: 2,
                thickness: 0.8,
                color: Colors.grey,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    upDownTextWidgetCreditLine(
                      title: 'Current Outstanding',
                      subtitle: '₹$formattedTransferredAmount/-',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    upDownTextWidgetCreditLine(
                      title: 'Total Billed Amount',
                      subtitle: '₹0/-',
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: upDownTextWidgetCreditLine(
                      title: 'Charges',
                      subtitle: '₹0/-',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 15),
                    child: upDownTextWidgetCreditLine(
                      title: 'Paid Amount',
                      subtitle: '₹0/-',
                    ),
                  ),
                ],
              ),
              // Flexible(
              //   flex: 2,
              //   child: Container(
              //     height: 120,
              //     width: 120,
              //     decoration: const BoxDecoration(),
              //     child: TubeProgressIndicator(
              //         amount: '₹$formattedCreditLineAmount/-',
              //         percentage: 25,
              //         taskName: 'Available limit'),
              //   ),
              // ),
            ],
          ),
        ],
      );
    },
  );
}

Widget upDownTextWidgetCreditLine(
    {required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      TextWidget(
        fontSize: 13,
        content: title,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
      TextWidget(
        fontSize: 17,
        content: subtitle,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ],
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

class RunningCreditLineWidget extends StatelessWidget {
  final int initialIndex;

  final Function(int index, CarouselPageChangedReason reason) onPageChanged;
  const RunningCreditLineWidget(
      {super.key, this.initialIndex = 0, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to make the widget responsive to different screen sizes
    final size = MediaQuery.of(context).size;
    print('screen height: ${size.height * 0.21}');
    final HomeController controller = Get.find<HomeController>();
    final RunningLoanModel? lastApprovedLoan = controller.getLastApprovedLoan();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16.0, right: 16, bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        // Responsive height using screen height
        height: 197,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            lastApprovedLoan == null
                ? const Center(child: Text("No approved loans found"))
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 200, // Making CarouselSlider responsive
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      onPageChanged: onPageChanged,
                    ),
                    items: [
                        creditLineSwiper(context, lastApprovedLoan),
                        // creditLineSwiper2(context),
                        creditLineSwiper3(context, lastApprovedLoan),
                      ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2].map((url) {
                int index = [1, 2].indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: initialIndex == index
                        ? AppColors.accentColor
                        : const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveTransferCardWidget extends StatelessWidget {
  const ResponsiveTransferCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('hello');
    // Accessing device size for responsive layout
    final size = MediaQuery.of(context).size;
    final HomeController controller = Get.find<HomeController>();
    final RunningLoanModel? lastApprovedLoan = controller.getLastApprovedLoan();



   // Safely convert String to double
    // double? transferredAmount = double.tryParse(lastApprovedLoan?.transferredAmount ?? '');
    double? amount = double.tryParse(lastApprovedLoan?.amount ?? '');


     // Parse and format the credit line and transferred amounts
  final double creditLineAmount = double.tryParse(lastApprovedLoan?.amount ?? "0") ?? 0.0;
  final double transferredAmount =
      double.tryParse(lastApprovedLoan?.transferredAmount ?? "0") ?? 0.0;

  // Calculate the available limit, ensuring it doesn't go below zero
  final double availableLimit =
      (creditLineAmount - transferredAmount).clamp(0.0, creditLineAmount);



print('available limit : $availableLimit');

    // Check if conversion was successful and compare
    if (lastApprovedLoan == null||
        amount == null ||
        transferredAmount > amount) {
      return const SizedBox(height: 13,); // Return empty container if conditions are not met
    }

    return Container(
      padding: EdgeInsets.only(
          left: 12.0, right: 12, top: size.height * 0.0149, bottom: 20),
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.accentColor.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/transfer_now.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Required Money',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Transfer your finovel creditline limit to your bank Account',
                  style: TextStyle(
                    fontSize: size.width * 0.032, // Responsive font size
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors
                            .accentColor, // Use your MyColor.primaryColor here
                      ),

                      child :  Obx(() => CustomButton(
                    buttonText: 'TRANSFER MONEY NOW',
                    fontSize: size.width *
                                0.03,

                    width: size.width * 0.4,
                    textColor: AppColors.whiteColor,
                    isLoading: controller.loading.value,
                    onPressed: ()  {
                      controller.handleTransfer();

                        },

                    )),

                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ResponsiveLoanOffersWidget extends StatelessWidget {
  final Function(int index, CarouselPageChangedReason reason) onOfferTap;
  final int pageNo;
  final List<LoanOffer> loanOffers;
  final bool isShowTitles;
  final bool isSvgImage;

  const ResponsiveLoanOffersWidget({
    super.key,
    required this.onOfferTap,
    this.pageNo = 0,
    this.isShowTitles = true,
    this.isSvgImage = true,
    required this.loanOffers,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isShowTitles
            ? const Padding(
                padding: EdgeInsets.only(
                  right: 16.0,
                  left: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exclusive Loan Offers for you',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17, // Responsive font size
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0, right: 8),
                      child: Text(
                        'Keep making payments on time to enjoy more benefits on your loans',
                        style: TextStyle(
                          fontSize: 13, // Responsive font size
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 0.85,
              onPageChanged: onOfferTap,
              enlargeCenterPage: true,
              height: 130.0),
          items: loanOffers.map((offer) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        InkWell(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const BigLoanSteps())),
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            height: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: MyColor.secondoryColor1,
                                ),
                                color: MyColor.cardFillColor),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            offer.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                fontFamily: 'SourceSans3',
                                                fontSize: 12),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              offer.subtitle,
                                              style: const TextStyle(
                                                  fontFamily: 'SourceSans3',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              offer.description,
                                              style: const TextStyle(
                                                  fontFamily: 'SourceSans3',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 4,
                                    child: isSvgImage
                                        ? SvgPicture.asset(
                                            offer.imageUrl,
                                            height: 130,
                                          )
                                        : Image.asset(
                                            offer.imageUrl,
                                            height: 130,
                                          )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyColor.offerLableColor),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 4.0, left: 8, right: 8),
                              child: Text(
                                offer.label,
                                style: const TextStyle(
                                    fontFamily: 'SourceSans3',
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.whiteColor,
                                    fontSize: 10),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            loanOffers.length,
            (index) => Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    // Optionally handle indicator tap
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    margin: const EdgeInsets.all(2.0),
                    child: Container(
                      width: pageNo == index ? 30 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: pageNo == index ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildVerificationSection(
    BuildContext context, HomeController controller) {
  final size = MediaQuery.sizeOf(context);
  bool isKycVisible = !controller.isKycVerified.value;
  bool isBankVisible =
      !controller.isBankVerified.value || !controller.isUpiVerified.value;

  // Determine if we should show a single, centered card or two cards side by side
  bool shouldCenterSingleCard =
      (isKycVisible && !isBankVisible) || (!isKycVisible && isBankVisible);
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: EdgeInsets.only(top: size.height * 0.033),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!controller.isKycVerified.value)
              Expanded(
                flex: 5,
                child: buildVerificationCard(
                  shouldCenter: shouldCenterSingleCard,
                  context: context,
                  onTap: () {
                    Get.toNamed(RouteHelper.kycScreen);
                    // Navigate to KYC Screen
                  },
                  imageAsset: 'assets/imgs/kyc.png',
                  title: 'Activate KYC',
                  description:
                      'To withdraw and get more loan amount complete your KYC',
                ),
              ),
            if (!controller.isBankVerified.value ||
                !controller.isUpiVerified.value)
              Expanded(
                flex: 5,
                child: buildVerificationCard(
                  context: context,
                  shouldCenter: shouldCenterSingleCard,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BankDetailsScreen()));
                  },
                  imageAsset: 'assets/imgs/add_bank.png',
                  title: 'Add Bank Account',
                  description:
                      'To withdraw and get more loan amount complete your KYC',
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

Widget buildVerificationCard({
  required BuildContext context,
  required VoidCallback onTap,
  required String imageAsset,
  required String title,
  required String description,
  required bool shouldCenter,
}) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey), // Use MyColor.borderStroke here
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 14, bottom: 8.0),
          child: Column(
            crossAxisAlignment: shouldCenter
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 3),
              Image.asset(imageAsset, height: 50),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SourceSans3',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'SourceSans3',
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
