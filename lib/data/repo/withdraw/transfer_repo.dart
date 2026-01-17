import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';

class TransferRepo {
  final ApiClient apiClient;
  TransferRepo({required this.apiClient});

  Future<ResponseModel> initiateTransfer(Map<String, dynamic> transferData) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.transferAmount}';
    ResponseModel model = await apiClient.request(url, Method.postMethod, transferData, passHeader: true);
    return model;
  }
}
