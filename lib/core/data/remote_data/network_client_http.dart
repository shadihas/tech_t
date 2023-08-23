import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../utils/utils.dart';

enum HttpMethod { GET, POST, DELETE, PUT }

abstract class NetworkClient {
  Future<bool> isNetworkAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Uri buildBaseUrl(String endPoint) {
    Uri url = Uri.parse(endPoint);
    if (!endPoint.startsWith('http'))
      url = Uri.parse('${Constants.BASE_URL}$endPoint');
    return url;
  }

  Future handleResponse(Response response, [bool? avoidTokenError]) async {
    print("Status Code: ${response.statusCode}");
    if (response.statusCode == 401) {
      throw jsonDecode(response.body)["message"];
    }

    if (response.statusCode >= 200 || response.statusCode <= 206) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500) {
      throw jsonDecode(response.body)["message"];
    } else if (response.statusCode == 403) {
      throw jsonDecode(response.body)["message"];
    } else if (response.statusCode == 429) {
      throw "Too many Requests";
    } else if (response.statusCode == 404) {
      throw jsonDecode(response.body)["message"];
    } else {
      try {
        throw jsonDecode(response.body)["message"];
      } on Exception catch (e) {
        throw "Something went wrong";
      }
    }
  }

  Future<Response> buildHttpResponse(String endPoint,
      {HttpMethod method = HttpMethod.GET,
      Map? body,
      Map<String, String>? queryParameters});
}

class NetworkClientHttp extends NetworkClient {
  NetworkClientHttp();

  @override
  Future<Response> buildHttpResponse(String endPoint,
      {HttpMethod method = HttpMethod.GET,
      Map? body,
      Map<String, String>? queryParameters}) async {
    if (await isNetworkAvailable()) {
      Uri url = buildBaseUrl(endPoint);
      if (queryParameters != null) {
        url = url.replace(queryParameters: queryParameters);
      }

      Response response;

      response =
          await get(url).timeout(const Duration(seconds: 60)).catchError((e) {
        throw "Your internet is not working";
      });

      return response;
    } else {
      throw "Your internet is not working";
    }
  }
}
