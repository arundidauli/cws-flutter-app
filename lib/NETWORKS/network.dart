import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cws/NETWORKS/utils.dart';
import 'package:cws/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'dialog_helper.dart';
import 'network_strings.dart';

///💥💥💥Created By Arun Android💥💥💥

class Network {
  static Dio? _dio;
  static CancelToken? _cancelRequestToken;
  static Network? _network;
  static int connectTimeOut = 20000;
  static int receivingTimeOut = 6000;

  Network._createInstance();

  factory Network() {
    if (_network == null) {
      _network = Network._createInstance();

      _dio = _getDio();
      _cancelRequestToken = _getCancelToken();
    }
    return _network!;
  }

  static Dio _getDio() {
    return _dio ??= Dio();
  }

  static CancelToken _getCancelToken() {
    return _cancelRequestToken ??= CancelToken();
  }

  ///💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 Get Request 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥
  Future<Response?> getRequest(
      {String baseUrl = API_BASE_URL,
      required String endPoint,
      Map<String, dynamic>? queryParameters}) async {
    Response? response;
    String? token = await Utility.getStringValue(tokenKey);
    if (await InternetConnectionChecker().hasConnection) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        response = await _dio!.get(baseUrl + endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
              headers: {
                'Accept': ACCEPT,
                'Authorization': token == null ? "" : "Bearer $token",
              },
              sendTimeout: Duration(milliseconds: receivingTimeOut),
              receiveTimeout: Duration(milliseconds: receivingTimeOut),
            ));
        //print(response);
      } on DioException catch (e) {
        log("Error 💥💥💥💥💥💥💥💥 :${e.response.toString()}");
        if (e.response?.statusCode == 403) {
          Utility().clearAll();
          getx.Get.offAll(()=> LoginScreen());
        }
        DialogHelper.showErrorDialog(
            title: "Server response", description: e.response?.data['message']);
      }
    } else {
      _noInternetConnection();
    }
    print(
        "➡️➡️➡️ API ➡️➡️➡️${API_BASE_URL + endPoint}\n\n➡️➡️➡️ Request ➡️➡️➡️$queryParameters\n\n✅✅✅ Response ✅✅✅$response");

    return response;
  }

  ///💥💥💥💥💥💥💥💥💥💥💥💥 Post Request 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥

  Future<Response?> postRequest({
    required String endPoint,
    Map<String, dynamic>? formData,
    bool isLoader = true,
  }) async {
    if (isLoader) {
      DialogHelper.showLoading();
    }
    Response? response;
    String? token = await Utility.getStringValue(tokenKey);
    if (await InternetConnectionChecker().hasConnection) {
      try {
        _dio?.options.connectTimeout = Duration(seconds: connectTimeOut);
        response = await _dio!.post(API_BASE_URL + endPoint,
            data: formData,
            queryParameters: formData,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: {
                  'Accept': ACCEPT,
                  'Authorization': token == null ? "" : "Bearer $token",
                },
                sendTimeout: Duration(milliseconds: receivingTimeOut),
                receiveTimeout: Duration(milliseconds: receivingTimeOut)));
        DialogHelper.hideLoading();
      } on DioException catch (e) {
        DialogHelper.hideLoading();
        print("$endPoint Dio: 💥💥💥💥💥💥💥💥💥💥💥💥 ${e.message}");
        if (e.response?.statusCode == 403) {
          Utility().clearAll();
          getx.Get.offAll(()=> LoginScreen());

        }
        DialogHelper.showErrorDialog(
            title: "Server response", description: e.response?.data['message']);
      }
    } else {
      _noInternetConnection();
    }
    print(
        "➡️➡️➡️ API ➡️➡️➡️${API_BASE_URL + endPoint}\n\n➡️➡️➡️ Request ➡️➡️➡️$formData\n\n✅✅✅ Response ✅✅✅$response");
    DialogHelper.hideLoading();
    return response;
  }




  ///💥💥💥💥💥💥💥💥💥💥💥💥 Upload File 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥

  Future<String?> uploadFile(File file, String type) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
      "type": type
    });
    DialogHelper.showLoading();
    Response? response;
    String? token = await Utility.getStringValue(tokenKey);

    if (await InternetConnectionChecker().hasConnection) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        response = await _dio!.post("${API_BASE_URL}image-upload",
            data: formData,
            cancelToken: _cancelRequestToken,
            options: Options(
              headers: {
                'Accept': ACCEPT,
                'Authorization': token == null ? "" : "Bearer $token",
              },
              sendTimeout: Duration(milliseconds: receivingTimeOut),
              receiveTimeout: Duration(milliseconds: receivingTimeOut),
            ));
        DialogHelper.hideLoading();
      } on DioException catch (e) {
        print(" Dio: 💥💥💥💥💥💥💥💥💥💥💥💥 ${e.message}");

        DialogHelper.hideLoading();
        if (e.response?.statusCode == 403) {
          Utility().clearAll();
          getx.Get.offAll(()=> LoginScreen());

        }
        DialogHelper.showErrorDialog(
            title: "Server response", description: e.response?.data['message']);
      }
    } else {
      _noInternetConnection();
    }
    print("uploadFileApi Response: 💥💥💥💥💥💥💥💥💥💥💥💥 $response");
    return response?.data["data"];
  }

  /// 💥💥💥💥💥💥💥💥💥💥💥💥 No Internet Connection 💥💥💥💥💥💥💥💥💥💥💥💥

  void _noInternetConnection() {
    DialogHelper.showErrorDialog(
        title: "Connection Error!",
        description: '💥💥💥💥No Internet Connection!💥💥💥💥');
  }
}
