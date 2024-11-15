import 'dart:async';

import 'package:dio/dio.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';

class DioUtil {
  static Dio? _instance;

  static Dio getInstance() {
    return _instance ??= createDioInstance();
  }

  static Dio createDioInstance() {
    // creating dio instance
    var dio = Dio(
      BaseOptions(
        baseUrl: API.BASE_URL,
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 3000),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
        },
      ),
    );

    // adding interceptor
    dio.interceptors.clear();

    dio.interceptors.add(RefreshTokenInterceptor());

    return dio;
  }
}

class RefreshTokenInterceptor extends Interceptor {
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;
  RefreshTokenInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    // Add the access token to the request header
    options.headers['Authorization'] =
        'Bearer ${SharedPrefs.instance.token ?? ''}';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    // If the response is successful, reset the refreshing flag
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    //catch the 401 here
    if (err.response?.statusCode == 401) {
      // If refresh token is not available, perform logout
      if ((await _getRefreshToken() ?? "").isEmpty) {
        // ... (Logout logic)
        return handler.reject(err);
      }
      if (!isRefreshing) {
        // Initiating token refresh
        isRefreshing = true;
        final refreshTokenResponse = await _refreshToken(err, handler);
        if (refreshTokenResponse.isSuccess) {
          // ... (Update headers and retry logic)
          err.requestOptions.headers['Authorization'] = 'Bearer ${SharedPrefs.instance.token ?? ''}';
        } else {
          // err.error = Errors(
          //   code: "511",
          //   message: "Session Expired",
          // );
          // If the refresh process fails, reject with the previous error
          return handler.next(err);
        }
      } else {
        // Adding errored request to the queue
        failedRequests.add({'err': err, 'handler': handler});
      }
    } else {
      return handler.next(err);
    }
  }

  Future<ResponseModel> _refreshToken(
      DioException err, ErrorInterceptorHandler handler) async {
    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: API.BASE_URL,
      ),
    );

    // handle refresh token
    var response = await retryDio.post(
      '/refresh-token',
      data: {
        "accessToken": _getUserAccessToken(),
        "refreshToken": _getRefreshToken(),
      },
      options: Options(
        headers: {"Content-Type": 'application/json'},
      ),
    );
    var parsedResponse = response.data;
    if (response.statusCode == 401 || response.statusCode == 403) {
      // handle logout
      return ResponseModel(false, "511");
    }
    if (response.statusCode == 200) {
      RefreshToken refreshTokenResponse = RefreshToken.fromJson(parsedResponse);
      if (refreshTokenResponse.errorCode != 511) {
        //save new refresh token and acces token
        saveUserRefreshToken(refreshTokenResponse.data?.refreshToken ?? "");
        saveUserAccessToken(refreshTokenResponse.data?.accessToken ?? "");

        failedRequests.add({'err': err, 'handler': handler});
        await retryRequests(parsedResponse['data']['accessToken']);
        return ResponseModel(true, "200");
      } else {
        isRefreshing = false;
        return ResponseModel(false, "511");
      }
    }
    return ResponseModel(false, "511");
  }

  Future<void> retryRequests(String accessToken) async {
    for (var request in failedRequests) {
      request['err'].requestOptions.headers['Authorization'] ='Bearer $accessToken';
      await request['handler'].next(request['err']);
    }
    failedRequests.clear();
    isRefreshing = false;
  }

  void saveUserRefreshToken(String refreshToken) {
    SharedPrefs.instance.setRefreshToken(refreshToken);
  }

  void saveUserAccessToken(String accessToken) {
    SharedPrefs.instance.setToken(accessToken);
  }

  Future<String?> _getUserAccessToken() async {
    return SharedPrefs.instance.token;
  }

  Future<String?> _getRefreshToken() async {
    return SharedPrefs.instance.refreshToken;
  }
}

class RefreshToken {
  RefreshToken({
    required this.data,
    required this.errorCode,
    required this.message,
  });

  final Data? data;
  final int errorCode;
  final String message;

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
        data: Data.fromJson(json["data"]),
        errorCode: json["errorCode"],
        message: json["message"],
      );
}

class Data {
  Data({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );
}

class ResponseModel {
  final bool isSuccess;
  final String message;

  ResponseModel(this.isSuccess, this.message);
}
