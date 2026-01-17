import 'package:finovelapp/data/model/bank/bank_detail.dart';
import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/services/api_service.dart';

class BankDetailsRepo {
  ApiClient apiClient;
  BankDetailsRepo({required this.apiClient});


  Future<ResponseModel> submitBankData(BankDetails bankDetails) async {
   final bankData = bankDetails.toJson();
    String url = '${UrlContainer.baseUrl}${UrlContainer.submitBankDetails}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, bankData, passHeader: true);
    return model;
  }
  Future<ResponseModel> submitUpiData(String upiId) async {
   Map<String, String> map = {
   "upi_id":upiId
};
    String url = '${UrlContainer.baseUrl}${UrlContainer.submitUPIDetails}';
    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return model;
  }





}
