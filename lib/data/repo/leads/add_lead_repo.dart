import 'dart:convert';

import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/leads/lead_form_model.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddLeadFormRepo {
  ApiClient apiClient;
  AddLeadFormRepo({required this.apiClient});


  Future<ResponseModel> submitLeadFormData(LeadFormModel leadFormModel) async {

    final leadFormData = leadFormModel.toJson();


    String url = '${UrlContainer.baseUrl}${UrlContainer.addLeadFormUrl}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, leadFormData, passHeader: true);
    return model;
  }

Future<ResponseModel> sendOtpPhone(String mobileNumber) async {
   Map<String, String> map = {
   "mobile":mobileNumber
};
    String url = '${UrlContainer.baseUrl}${UrlContainer.sendOtpPhone}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return model;
  }



Future<ResponseModel> verifyOtpPhone(String mobileNumber, String otp) async {
   Map<String, String> map = {
   "mobile":mobileNumber,
   "otp":otp
};
    String url = '${UrlContainer.baseUrl}${UrlContainer.verifyOtpPhone}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return model;
  }

  Future<ResponseModel> sendOtpEmail(String email) async {
   Map<String, String> map = {
   "email":email
};
    String url = '${UrlContainer.baseUrl}${UrlContainer.sendOtpEmail}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return model;

  }

  Future<ResponseModel> verifyOtpEmail(String email, String otp) async {
   Map<String, String> map = {
   "email":email,
   "otp":otp
};
    String url = '${UrlContainer.baseUrl}${UrlContainer.verifyOtpEmail}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return model;
  }

  Future<String> authenticate(String apiKey, String apiSecret) async {
    const String apiUrl = '${UrlContainer.baseUrl}${UrlContainer.sandboxAuthenticate}';
    debugPrint('apiUrl : $apiUrl');


    // var response = await http.post(Uri.parse(apiUrl), headers: headers);
    var response = await apiClient.request(apiUrl, Method.postMethod, {}, passHeader: true);
    debugPrint('Response status: ${response.message}');
    if (response.message == 'Success') {
      debugPrint('response json : ${response.responseJson}');
      var data = json.decode(response.responseJson);
      String accessToken = data['access_token'];
      return accessToken;
    } else {
      throw Exception("Failed to authenticate with the API");
    }
  }

  Future<dynamic> requestAadharOtp(String aadharNumber, String token) async {
  var headers = {
    'Authorization': token,
    'accept': 'application/json',
    'content-type': 'application/json',
    'x-api-key': apiKey,
    'x-api-version': '1.0',
  };

  var body = json.encode({"aadhaar_number": aadharNumber});

  try {
    final  response = await http.post(
      Uri.parse('https://api.sandbox.co.in/kyc/aadhaar/okyc/otp'),
      headers: headers,
      body: body,
    );
    debugPrint('Response status: ${response.body}');

    if (response.statusCode == 200) {
      final  data = json.decode(response.body);
      return data['data']['ref_id']; // Return ref_id here
    } else {
      final  errorData = json.decode(response.body);
      return errorData; // Return the whole error response
    }
  } catch (e) {
    debugPrint('An error occurred: $e');
    return {"message": "An error occurred: $e"}; // Return error message in case of exception
  }
}


  Future<dynamic> verifyAadharOtp(String otp, String refId, String token) async {
    var headers = {
      'Authorization': token,
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'x-api-version': '1.0',
    };

    var body = json.encode({
      "otp": otp,
      "ref_id": refId,
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.sandbox.co.in/kyc/aadhaar/okyc/otp/verify'),
        headers: headers,
        body: body,
      );
      debugPrint('Response status: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data; // Return kyc_id here
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
          final  errorData = json.decode(response.body);
      return errorData; // Return the whole error response

      }
    } catch (e) {
      debugPrint('An error occurred: $e');
       throw Exception('An error occurred during Aadhaar OTP verification: $e'); // Rethrow or handle exception appropriately

    }
  }

  // verifyPanNumber

  Future<dynamic> verifyPanNumber(String panNumber, String token) async {
    var headers = {
      'Authorization': token,
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'x-api-version': '1.0',
    };

    var body = json.encode({"pan": panNumber,"consent": "Y",
     "reason": "For KYC of User"},);

    try {
      var response = await http.post(
        Uri.parse('https://api.sandbox.co.in/kyc/pan'),
        headers: headers,
        body: body,
      );
      debugPrint('Response status: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data; // Return kyc_id here
      } else {

      final  errorData = json.decode(response.body);
      return errorData; // Return the whole error response
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
       return {"message": "An error occurred: $e"}; // Rethrow or handle exception appropriately

    }
  }



}
