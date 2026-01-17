import 'package:finovelapp/core/utils/method.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/global/response_model/response_model.dart';
import 'package:finovelapp/data/services/api_service.dart';

class ChannelPartnerDashboardRepo {
  final ApiClient apiClient;
  ChannelPartnerDashboardRepo({required this.apiClient});

  Future<ResponseModel> fetchPartnerDashboardInfo() async {
    const String url = '${UrlContainer.baseUrl}${UrlContainer.channelPartnerDashboardEndpoint}';
    final response = await apiClient.request(url, Method.getMethod, {}, passHeader: true);

    return response;


  }
}