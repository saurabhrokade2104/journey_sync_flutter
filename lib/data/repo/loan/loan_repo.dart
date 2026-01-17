import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/repo/kyc/kyc_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import '../../model/dynamic_form/form.dart';
import 'package:http/http.dart' as http;

class LoanRepo {
  ApiClient apiClient;
  LoanRepo({required this.apiClient});

  Future<ResponseModel> getLoanPlan() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.loanPlanUrl}";

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> submitLoanPlan(
      String planId, String amount, String? authMode) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.loanApplyUrl}$planId';
    Map<String, dynamic> params = {'amount': amount};

    if (authMode != null &&
        authMode.isNotEmpty &&
        authMode.toLowerCase() != MyStrings.selectOne.toLowerCase()) {
      params['auth_mode'] = authMode.toLowerCase();
    }
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getMyLoanList(
      int page, String status, String loanNumber) async {
    //?search=sdfasdfdsf
    String srcUrl =
        "${UrlContainer.baseUrl}${UrlContainer.myloanListUrl}?search=$loanNumber";

    String url = status == '999'
        ? "${UrlContainer.baseUrl}${UrlContainer.myloanListUrl}?page=$page"
        : "${UrlContainer.baseUrl}${UrlContainer.myloanListUrl}?page=$page&status=$status";
    log(url);
    ResponseModel responseModel = await apiClient.request(
        loanNumber.isNotEmpty ? srcUrl : url, Method.getMethod, null,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getLoanInstallmentLog(String dpsId, int page) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.loanInstalmentUrl}$dpsId?page=$page";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> confirmLoanPlan(
      String planId, String amount, String? authMode) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.loanApplyUrl}$planId';
    Map<String, dynamic> params = {'amount': amount};

    if (authMode != null &&
        authMode.isNotEmpty &&
        authMode.toLowerCase() != MyStrings.selectOne.toLowerCase()) {
      params['auth_mode'] = authMode.toLowerCase();
    }
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<dynamic> confirmLoanRequest(String planId, String amount,
      List<FormModel> list, String twoFactorCode) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.loanConfirmUrl}$planId';

    apiClient.initToken();
    await modelToMap(list);
    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String, String> finalMap = {};

    for (var element in fieldList) {
      finalMap.addAll(element);
    }

    request.headers
        .addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});

    for (var file in filesList) {
      request.files.add(http.MultipartFile(file.key ?? '',
          file.value.readAsBytes().asStream(), file.value.lengthSync(),
          filename: file.value.path.split('/').last));
    }

    request.fields.addAll({'amount': amount});
    if (twoFactorCode.isNotEmpty) {
      request.fields.addAll({'authenticator_code': twoFactorCode});
    }

    request.fields.addAll(finalMap);

    http.StreamedResponse response = await request.send();
    String jsonResponse = await response.stream.bytesToString();
    ResponseModel responseModel = ResponseModel(response.statusCode == 200,
        '${response.reasonPhrase}', response.statusCode, jsonResponse);

    return responseModel;
  }
  Future<AuthorizationResponseModel> submitBnplLoanApplication(String planId, String amount, Map<String, dynamic> formData, String twoFactorCode) async {
  String url = '${UrlContainer.baseUrl}${UrlContainer.loanConfirmUrl}$planId';

  apiClient.initToken();
  var request = http.MultipartRequest('POST', Uri.parse(url));

  // Authorization header
  request.headers.addAll({'Authorization': 'Bearer ${apiClient.token}'});

  // Adding fields
  request.fields.addAll({
    'amount': amount,
    if (twoFactorCode.isNotEmpty) 'authenticator_code': twoFactorCode,
    ...formData.map((key, value) => MapEntry(key, value.toString())), // Ensuring all values are strings
  });

  // Handling file uploads
  formData.forEach((key, value) {
    if (value is File) {
      request.files.add(
        http.MultipartFile(
          key,
          value.readAsBytes().asStream(),
          value.lengthSync(),
          filename: value.path.split('/').last,
        ),
      );
    }
  });

  http.StreamedResponse response = await request.send();
  String jsonResponse = await response.stream.bytesToString();

  // return ResponseModel(
  //   response.statusCode == 200,
  //   response.reasonPhrase ?? 'Unknown Error',
  //   response.statusCode,
  //   jsonResponse,
  // );

  AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

  // Print the response (for debugging purposes)
  print('Response: $jsonResponse');

  return model;

}

  Future<dynamic> modelToMap(List<FormModel> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.file != null) {
          filesList.add(ModelDynamicValue(e.label, e.file!));
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }

  Future<ResponseModel> retrieveEligibilityFormData() {

    String url = '${UrlContainer.baseUrl}${UrlContainer.eligibilityFormUserData}';
    return apiClient.request(url, Method.getMethod, null, passHeader: true);


  }
}
