import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'dart:convert';

import 'json_convert_content.dart';

enum ResponseResultType {
  // 未知
  unKnow,
  // 成功
  success,
  // 错误
  error,
}

/// 请求结果
class ResponseResult<T> {
  ResponseResultType state;
  int stateID = -1;
  List<T> list;
  // Map<String, T> map;
  T result;
  dynamic any;
  Error error;

  ResponseResult<T> checkResponse(Response re) {
    ResponseResult<T> result = ResponseResult();
    result.any = re.data;
    result.stateID = re.statusCode;
    if (re.statusCode == 200) {
      result.state = ResponseResultType.success;
    } else {
      result.state = ResponseResultType.error;
    }
    if (re.data is Map) {
      Map<String, dynamic> json = re.data;
      result.result = JsonConvert.fromJsonAsT<T>(json);
    } else if (re.data is List) {
      final parsed = re.data.cast<Map<String, dynamic>>();
      print(parsed.runtimeType);
      var list =
          parsed.map<T>((json) => JsonConvert.fromJsonAsT<T>(json)).toList();
      result.list = list;
    } else {}
    return result;
  }

  ResponseResult createWithError<T>(DioError dioError) {
    ResponseResult result = ResponseResult();
    // 超时
    if (dioError.type == DioErrorType.connectTimeout) {}
    if (dioError.type == DioErrorType.other) {}
    result.state = ResponseResultType.error;

    // debug模式才打印
    if (!kReleaseMode) {
      print('请求异常: ' + dioError.toString());
      print('请求异常url: ' + dioError.response.realUri.toString());
    }
    return result;
  }
}

class NetUtils {
  static const String NET_GET = "GET";
  static const String NET_POST = "POST";
  static const String NET_DELETE = "DELETE";
  static const String NET_PUT = "PUT";

  static const String SERVER_VERSION_1 = "v1";
  static const String SERVER_VERSION_2 = "v2";

  static final NetUtils _singleton = NetUtils._internal();

  static NetUtils get instance => NetUtils();

  factory NetUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  NetUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 60 * 1000,
      receiveTimeout: 60 * 1000,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);

    /// 打印Log
    if (kReleaseMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
        ),
      );
    } else {
      _dio.interceptors.add(
        LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: true,
            responseHeader: true),
      );
    }
  }

  /// 调用dio进行网络请求
  Future _request<T>(
    String method,
    String url, {
    String version,
    Map<String, dynamic> body,
    Map<String, dynamic> header,
    Map<String, dynamic> params,
    Function(ResponseResult<T> result) finished,
  }) async {
    Response response;
    try {
      switch (method) {
        case NET_GET:
          Options options = requestBaseHeader(
            header,
            url,
            NET_GET,
            body,
            version,
          );
          response = await _dio.get(
            url,
            queryParameters: params,
            options: options,
          );
          break;
        case NET_POST:
          Options options = requestBaseHeader(
            header,
            url,
            NET_POST,
            body,
            version,
          );
          response = await _dio.post(
            url,
            data: body,
            options: options,
          );
          break;
        case NET_DELETE:
          Options options = requestBaseHeader(
            header,
            url,
            NET_DELETE,
            body,
            version,
          );
          response = await _dio.post(
            url,
            data: body,
            options: options,
          );
          break;
      }
      ResponseResult<T> result = ResponseResult<T>().checkResponse(response);
      finished?.call(result);
      return result;
    } on DioError catch (dioError) {
      // 请求错误处理
      ResponseResult result = ResponseResult().createWithError<T>(dioError);
      finished?.call(result);
      return result;
    }
  }

  /// 主动发起请求 get
  Future get<T>(
    String url, {
    String version,
    Map<String, dynamic> header,
    Map<String, dynamic> params,
    Function(ResponseResult<T> result) finished,
  }) {
    return _request<T>(
      NET_GET,
      url,
      version: version,
      header: header,
      params: params,
      finished: finished,
    );
  }

  /// 主动发起请求 post
  Future post<T>(
    String url, {
    String version,
    Map<String, dynamic> body,
    Map<String, dynamic> header,
    Map<String, dynamic> params,
    Function(ResponseResult<T> result) finished,
  }) {
    return _request<T>(
      NET_POST,
      url,
      version: version,
      body: body,
      header: header,
      params: params,
      finished: finished,
    );
  }

  /// 主动发起请求 post
  Future del<T>(
    String url, {
    String version,
    Map<String, dynamic> body,
    Map<String, dynamic> header,
    Map<String, dynamic> params,
    Function(ResponseResult<T> result) finished,
  }) {
    return _request<T>(
      NET_DELETE,
      url,
      version: version,
      body: body,
      header: header,
      params: params,
      finished: finished,
    );
  }

  // header 参数
  Options requestBaseHeader(
    Map<String, dynamic> headerParams,
    String url,
    String method,
    Map<String, dynamic> body,
    String version,
  ) {
    Options options = Options();
    if (headerParams == null) {
      headerParams = new Map<String, String>();
    }
    // headerParams["Accept"] = "application/json";
    // headerParams["Access-Control-Allow-Origin"] = "*";
    // headerParams["Access-Control-Allow-Credentials"] = "true";
    // headerParams["Access-Control-Allow-Methods"] =
    //     "GET, POST, PATCH, PUT, DELETE, OPTIONS";
    // headerParams["Access-Control-Allow-Headers"] =
    //     "Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since, X-CSRF-TOKEN, X-Requested-With";
    // headerParams["Origin"] = "39.105.178.125";
    // headerParams[]
    // headerParams["Access-Control-Expose-Headers"] = "*";

    // options.headers.addAll(
    //   new Map<String, String>.from(headerParams),
    // );
    return options;
  }
}
