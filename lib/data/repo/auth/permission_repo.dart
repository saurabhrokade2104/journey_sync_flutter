import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/authorization/authorization_response_model.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';

class PermissionDetailsRepo {
  ApiClient apiClient;
  PermissionDetailsRepo({required this.apiClient});


  // Future<ResponseModel> submitDeviceData(Map<String, dynamic> data) async {



  //   String url = '${UrlContainer.baseUrl}${UrlContainer.submitDeviceData}';
  //   ResponseModel model =
  //       await apiClient.request(url, Method.postMethod, data, passHeader: true,encodeData: false);
  //       debugPrint('response body device data : ${model.message}');
  //   return model;
  // }


Future<bool> submitDeviceData(Map<String, String> data) async {

    try {
      apiClient.initToken();
      String url = '${UrlContainer.baseUrl}${UrlContainer.submitDeviceData}';
      var request = http.MultipartRequest('POST', Uri.parse(url));


      request.headers.addAll(
          <String, String>{'Authorization': 'Bearer ${apiClient.token}'});


      request.fields.addAll(data);
      http.StreamedResponse response = await request.send();
      String jsonResponse = await response.stream.bytesToString();
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        CustomSnackBar.success(successList: model.message?.success ?? [MyStrings.success]);
        return true;
      } else {
        CustomSnackBar.error(errorList: model.message?.error ?? [MyStrings.requestFail]);
        return false;
      }
    } catch (e) {
      return false;
    }

    // String encodedData = jsonEncode(data);


    // String url = '${UrlContainer.baseUrl}${UrlContainer.submitDeviceData}';
    // ResponseModel model =
    //     await apiClient.request(url, Method.postMethod, data, passHeader: true,encodeData: true);
    //     debugPrint('response body device data : ${model.message}');
    // return model;


  }



}
