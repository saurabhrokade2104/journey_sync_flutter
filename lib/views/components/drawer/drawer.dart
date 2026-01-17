import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/account/profile_controller.dart';
import 'package:finovelapp/data/controller/menu_/menu_controller.dart' as menu;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget drawerWidget(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        GetBuilder<ProfileController>(
          builder: (profileController) {
            double emailFontSize = 16;
            String email = profileController.model.data?.user?.email ?? '';
            if (email.length > 30) {
              emailFontSize = 14;
            }
            return DrawerHeader(
              child: SizedBox(
                height: double.infinity,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                        ),
                        child: Center(
                          child: Text(
                            profileController.model.data?.user?.username!
                                    .substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: const TextStyle(
                                color: MyColor.whiteColor, fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profileController.model.data?.user?.firstname} ${profileController.model.data?.user?.lastname}',
                              style: TextStyle(fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 360
                                          ? 16
                                          : 14),
                              softWrap: true,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              profileController.model.data?.user?.mobile ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        GetBuilder<menu.MenuController>(builder: (menuController) {
          return Column(
            children: [
              const SizedBox(height: 5),
              GetBuilder<ProfileController>(builder: (controller) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Referral Code : ${controller.model.data?.user?.referralCode ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                              text: controller.model.data?.user?.referralCode ??
                                  ''));
                        },
                        child: const Icon(Icons.copy))
                  ],
                );
              }),

              const SizedBox(
                height: 13,
              ),

              // ListTile(
              //   leading: const Icon(
              //     Icons.account_circle_outlined, // Updated icon for "My Profile"
              //   ),
              //   trailing: const Icon(Icons.navigate_next),
              //   title: const Text(
              //     'My Profile',
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Get.toNamed(RouteHelper.applyLoanScreen,
              //     //     arguments: [true]);
              //      Navigator.of(context).push(MaterialPageRoute(
              //                     builder: (context) =>
              //                         const LoanApplicationScreen()));
              //   },
              // ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.card_membership, // Updated icon for "Membership"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Membership',
                ),
                onTap: () {
                  // Navigator.pop(context);
                  // Get.toNamed(RouteHelper.eligibilityCheckForm,
                  //     arguments: [true]);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.assignment_turned_in_outlined, // Updated icon for "Lead Status"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Lead Status',
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(RouteHelper.mySalesDashboardScreen,
                      arguments: [true]);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.help_outline, // Updated icon for "Help & Support"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Help & Support',
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(RouteHelper.faqScreen);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.monetization_on_outlined, // Updated icon for "Payout Structure"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Payout Structure',
                ),
                onTap: () {
                  // Navigator.pop(context);
                  // Get.toNamed(RouteHelper.faqScreen);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.note_add_outlined, // Updated icon for "Terms & Policies"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Terms & Policies',
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(RouteHelper.privacyScreen);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.share, // Updated icon for "Refer & Earn"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Refer & Earn',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.video_library_outlined, // Updated icon for "Training Videos"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Training Videos',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.logout, // Updated icon for "Log Out"
                ),
                trailing: const Icon(Icons.navigate_next),
                title: const Text(
                  'Log Out',
                ),
                onTap: () {
                  Navigator.pop(context);
                  menuController.logout();
                },
              ),

              const Divider(),
            ],
          );
        })
      ],
    ),
  );
}
