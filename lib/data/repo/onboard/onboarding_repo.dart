
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:get/get.dart';

import '../../model/onboarding_model.dart';

class OnBoardingRepo {

  Future<Response> getOnBoardingList() async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(MyImages.onboard_1, 'Your Financial Journey Starts Here!', 'Join the Finovel family and experience a seamless and secure way to manage your loans and finances.'),
        OnBoardingModel(MyImages.onboard_2, 'Get Loans with Ease', 'Apply, verify, and receive funds with just a few taps. Our streamlined process is fast, easy, and transparent.'),
        OnBoardingModel(MyImages.onboard_3, 'Your Security, Our Priority', 'With advanced encryption and compliance with financial regulations, we ensure your data and transactions are always protected.'),
      ];

      Response response = Response(body: onBoardingList, statusCode: 200);
      return response;
    } catch (e) {
      return const Response(statusCode: 404, statusText: 'Onboarding data not found');
    }
  }
}
