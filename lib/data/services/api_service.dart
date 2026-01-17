import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finovelapp/core/helper/shared_preference_helper.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_images.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/general_setting/general_settings_response_model.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/views/components/buttons/circle_animated_button_with_text.dart';

class ApiClient extends GetxService {
  SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<ResponseModel> request(
    String uri,
    String method,
    Map<String, dynamic>? params, {
    bool passHeader = false,
    bool encodeData = false,
    bool isOnlyAcceptType = false,
    bool isBioMetricLogin = false,
  }) async {
    Uri url = Uri.parse(uri);
    http.Response response;

    debugPrint('Request URL: $url');
    debugPrint('Request Method: $method');
    debugPrint('Request Params: $params');

    try {
      if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          if (isOnlyAcceptType) {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
            });
          } else if (encodeData == true) {
            response = await http.post(url, body: jsonEncode(params), headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": "$tokenType $token"
            });
          } else {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
              "Authorization": "$tokenType $token"
            });
          }
        } else {
          response = await http.post(url, body: params);
        }
        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
      } else if (method == Method.deleteMethod) {
        response = await http.delete(url);
      } else if (method == Method.updateMethod) {
        response = await http.patch(url);
      } else {
        if (passHeader) {
          initToken();

          if (isBioMetricLogin) {
            String? authToken = await secureStorage.read(key: 'auth_token');
            debugPrint(' Get Sending Token: $authToken');
            response = await http.get(url, headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $authToken",
              "isBioMetricLogin": "true"
            });
          } else {
            response = await http.get(url, headers: {
              "Accept": "application/json",
              "Authorization": "$tokenType $token"
            });
          }
          debugPrint(' Get Response Status Code: ${response.statusCode}');
          debugPrint(' Get Response Body: ${response.body}');
        } else {
          response = await http.get(url);
        }
      }

      debugPrint('status code api service : ${response.statusCode}');
      debugPrint('response body api service : ${(response.body.toString())}');
      debugPrint(url.toString());
      debugPrint(token);
      debugPrint(params.toString());

      if (response.statusCode != 200) {
        debugPrint('Non-200 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        debugPrint(response.body.toString());
        try {
          AuthorizationResponseModel model =
              AuthorizationResponseModel.fromJson(jsonDecode(response.body));
          debugPrint('modeel remark " ${model.remark}');
          if (model.remark == 'profile_incomplete') {
            Get.toNamed(RouteHelper.profileCompleteScreen);
          } else if (model.remark == 'kyc_verification') {
            Get.offAndToNamed(RouteHelper.kycScreen);
          } else if (model.remark == 'unauthenticated') {
            sharedPreferences.setBool(
                SharedPreferenceHelper.rememberMeKey, false);
            sharedPreferences.remove(SharedPreferenceHelper.token);
            Get.offAllNamed(RouteHelper.loginScreen);
          }
        } catch (e) {
          e.toString();
        }

        return ResponseModel(true, 'Success', 200, response.body);
      } else if (response.statusCode == 401) {
        sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
        Get.offAllNamed(RouteHelper.loginScreen);
        return ResponseModel(
            false, MyStrings.unAuthorized.tr, 401, response.body);
      } else if (response.statusCode == 500) {
        return ResponseModel(
            false, MyStrings.serverError.tr, 500, response.body);
      } else {
        return ResponseModel(
            false, MyStrings.somethingWentWrong.tr, 499, response.body);
      }
    } on SocketException catch (e) {
      debugPrint('SocketException: ${e.toString()}');

      return ResponseModel(false, MyStrings.noInternet.tr, 503, '');
    } on FormatException catch (e) {
      debugPrint('FormatException: ${e.toString()}');
      return ResponseModel(false, MyStrings.badResponseMsg.tr, 400, '');
    } catch (e) {
      debugPrint('General Error: ${e.toString()}');
      return ResponseModel(false, MyStrings.somethingWentWrong.tr, 499, '');
    }
  }

  String token = '';
  String tokenType = '';

  initToken() {
    if (sharedPreferences.containsKey(SharedPreferenceHelper.accessTokenKey)) {
      String? t =
          sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey);
      String? tType =
          sharedPreferences.getString(SharedPreferenceHelper.accessTokenType);
      token = t ?? '';
      tokenType = tType ?? 'Bearer';
    } else {
      token = '';
      tokenType = 'Bearer';
    }
  }

  storeGeneralSetting(GeneralSettingsResponseModel model) {
    String json = jsonEncode(model.toJson());
    sharedPreferences.setString(SharedPreferenceHelper.generalSettingKey, json);
    getGSData();
  }

  void disableIntro() {
    sharedPreferences.setBool('finovel-intro', false);
  }

  bool? showIntro() {
    return sharedPreferences.getBool('finovel-intro');
  }

  GeneralSettingsResponseModel getGSData() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    if (pre.isNotEmpty && pre != 'null') {
      GeneralSettingsResponseModel model =
          GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
      return model;
    } else {
      GeneralSettingsResponseModel model = GeneralSettingsResponseModel();
      return model;
    }
  }

  String getCurrencyOrUsername(
      {bool isCurrency = true, bool isSymbol = false}) {
    if (isCurrency) {
      String pre = sharedPreferences
              .getString(SharedPreferenceHelper.generalSettingKey) ??
          '';
      if (pre.isNotEmpty && pre != '') {
        GeneralSettingsResponseModel model =
            GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
        String currency = isSymbol
            ? model.data?.generalSetting?.curSym ?? ''
            : model.data?.generalSetting?.curText ?? '';

        return currency;
      }
      return '';
    } else {
      String username =
          sharedPreferences.getString(SharedPreferenceHelper.userNameKey) ?? '';
      return username;
    }
  }

  bool getPasswordStrengthStatus() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingsResponseModel model =
        GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    bool checkPasswordStrength =
        model.data?.generalSetting?.securePassword.toString() == '0'
            ? false
            : true;
    return checkPasswordStrength;
  }

  int getOtpTimerTime() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingsResponseModel model =
        GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    String timer = model.data?.generalSetting?.otpTime ?? '300';
    return int.tryParse(timer) ?? 300;
  }

  List<String> getAuthorizationList() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingsResponseModel model =
        GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    List<String> authList = [];
    String selectOne = MyStrings.selectOne;
    authList.insert(0, selectOne);
    bool isEmailEnable =
        model.data?.generalSetting?.modules?.otpEmail == '1' ? true : false;
    bool isSMSEnable =
        model.data?.generalSetting?.modules?.otpSms == '1' ? true : false;
    if (isEmailEnable) {
      authList.add(MyStrings.email);
    }
    if (isSMSEnable) {
      authList.add(MyStrings.sms);
    }
    return authList;
  }

  List<Widget> getModuleList() {
    List<Widget> moduleList = [];

    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    if (pre.isNotEmpty) {
      GeneralSettingsResponseModel model =
          GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
      bool isDepositEnable =
          model.data?.generalSetting?.modules?.deposit == '0' ? false : true;
      bool isWithdrawEnable =
          model.data?.generalSetting?.modules?.withdraw == '0' ? false : true;

      bool isLoanEnable =
          model.data?.generalSetting?.modules?.loan == '0' ? false : true;

      // bool isWireTransferEnable = model.data?.generalSetting?.modules?.referralSystem=='0'?false:true;

      if (isDepositEnable) {
        moduleList.add(CircleAnimatedButtonWithText(
          buttonName: MyStrings.deposit,
          height: 40,
          width: 40,
          backgroundColor: MyColor.transparentColor,
          child: SvgPicture.asset(MyImages.depositIcon,
              color: MyColor.primaryColor, height: 20, width: 20),
          onTap: () {
            Get.toNamed(RouteHelper.depositsScreen);
          },
        ));
      }

      if (isLoanEnable) {
        moduleList.add(CircleAnimatedButtonWithText(
          buttonName: MyStrings.loan,
          height: 40,
          width: 40,
          backgroundColor: MyColor.transparentColor,
          child: Image.asset(
            MyImages.loanIcon1,
            color: MyColor.primaryColor,
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Get.toNamed(RouteHelper.loanScreen);
          },
        ));
      }
      if (isWithdrawEnable) {
        moduleList.add(CircleAnimatedButtonWithText(
          buttonName: MyStrings.withdrawal,
          height: 40,
          width: 40,
          backgroundColor: MyColor.transparentColor,
          child: SvgPicture.asset(MyImages.withdrawIcon,
              color: MyColor.primaryColor, height: 20, width: 20),
          onTap: () {
            Get.toNamed(RouteHelper.withdrawScreen);
          },
        ));
      }

      moduleList.add(CircleAnimatedButtonWithText(
        buttonName: MyStrings.transaction,
        height: 40,
        width: 40,
        backgroundColor: MyColor.transparentColor,
        child: SvgPicture.asset(MyImages.transactionIcon,
            color: MyColor.primaryColor, height: 20, width: 20),
        onTap: () {
          Get.toNamed(RouteHelper.transactionScreen);
        },
      ));
    }
    return moduleList;
  }

  bool isWireTransferEnable() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingsResponseModel model =
        GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    bool isWireTransferEnable =
        model.data?.generalSetting?.modules?.referralSystem == '0'
            ? false
            : true;

    return isWireTransferEnable;
  }

  String getTemplateName() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '';
    GeneralSettingsResponseModel model =
        GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    String templateName = model.data?.generalSetting?.activeTemplate ?? '';
    return templateName;
  }
}
