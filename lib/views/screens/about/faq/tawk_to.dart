import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/data/controller/account/profile_controller.dart';
import 'package:finovelapp/data/repo/account/profile_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';

import 'package:get/get.dart';

class TawkSupport extends StatefulWidget {
  const TawkSupport({super.key});

  @override
  State<TawkSupport> createState() => _TawkSupportState();
}

class _TawkSupportState extends State<TawkSupport> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));






    Get.put(ProfileRepo(
      apiClient: Get.find(),
    ));
    Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Get.find<ProfileController>().loadProfileInfo();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Finovel Support'),
          backgroundColor: MyColor.lPrimaryColor,
          elevation: 0,
        ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return Tawk(

              directChatLink: 'https://tawk.to/chat/66079f65a0c6737bd12664d5/1hq6sd98r',
              visitor: TawkVisitor(
                name: controller.model.data?.user?.firstname  ??
                                    'User',
                email: controller.model.data?.user?.email ?? '',
              ),
              onLoad: () {
                print('Hello Tawk!');
              },
              onLinkTap: (String url) {
                print(url);
              },
              placeholder: const Center(
                child: Text('Loading...'),
              ),
            );
        }
      ),
    );
  }
}