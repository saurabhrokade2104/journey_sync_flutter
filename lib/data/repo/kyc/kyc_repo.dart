import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/model/kyc/kyc_response_model.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class KycRepo {
  ApiClient apiClient;
  KycRepo({required this.apiClient});

  Future<KycResponseModel> getKycData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.kycFormUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      KycResponseModel model =
          KycResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        return model;
      } else {
        if (model.remark?.toLowerCase() != 'already_verified' &&
            model.remark?.toLowerCase() != 'under_review') {
          CustomSnackBar.error(
              errorList:
                  model.message?.error ?? [MyStrings.somethingWentWrong]);
        }
        return model;
      }
    } else {
      return KycResponseModel();
    }
  }

  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<AuthorizationResponseModel> submitKycData(Map<String, dynamic> formData) async {
  apiClient.initToken();
  String url = '${UrlContainer.baseUrl}${UrlContainer.kycSubmitUrl}';
  var request = http.MultipartRequest('POST', Uri.parse(url));

  print('formData : $formData');

  // Add headers
  request.headers.addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});

  // Process formData and add to request
  for (var key in formData.keys) {
    var value = formData[key];
    if (value is File) {
      // If value is File, add it as a MultipartFile
      request.files.add(http.MultipartFile(key, value.readAsBytes().asStream(), value.lengthSync(), filename: value.path.split('/').last));
    } else {
      // Otherwise, add it as a field
      request.fields[key] = value.toString();
    }
  }

  // Print the entire request (for debugging purposes)
  print('Complete Request: $request');

  // Send the request
  http.StreamedResponse response = await request.send();

  String jsonResponse = await response.stream.bytesToString();
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
        if (e.imageFile != null) {
          filesList.add(ModelDynamicValue(e.label, e.imageFile!));
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }
}

class ModelDynamicValue {
  String? key;
  dynamic value;
  ModelDynamicValue(this.key, this.value);
}
