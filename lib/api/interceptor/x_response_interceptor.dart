/*
 * 文件名称: x_response_interceptor.dart
 * 创建时间: 2025/10/22 16:31:29
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:xkit/api/x_base_resp.dart';
import 'package:xkit/helper/x_loading.dart';
import 'package:xkit/helper/x_public.dart';

/// 拦截器 数据初步处理
class XResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      if (response.data is! ResponseBody) {
        if (response.data is Map) {
          ResponseHandler.printResponse(response);
          handler.resolve(response);
          return;
        } else {
          ResponseHandler.handleUnexpectedResponse(response);
          handler.next(response);
          return;
        }
      } else if (response.data is ResponseBody) {
        // 处理流式响应
        ResponseHandler.printResponse(response);
        handler.resolve(response);
        return;
      }
    } catch (e, stackTrace) {
      if (response.requestOptions.extra['showLoading'] == true) {
        XLoading.dismiss();
      }

      final result = ResponseHandler.handleException(e, stackTrace);
      xShowToast(result.toString(), stackTrace: stackTrace);
      handler.reject(DioException(requestOptions: response.requestOptions, error: result));
    }
  }
}

class ResponseHandler {
  // /// 处理 Token 过期
  // static Future<Response?> handleTokenExpired(
  //   Response response,
  //   ResponseInterceptorHandler? handler,
  // ) async {
  //   try {
  //     var localUser = XUserManager().userInfo;
  //     localUser.needRefresh = true;
  //     await XUserManager().saveUserInfo(localUser);
  //     final user = await XUserService().refreshToken();
  //     if (user != null) {
  //       // 保存新 Token
  //       XUserManager().saveNewToken(user);
  //       // 使用新 Token 重新发起之前的请求
  //       if (response.requestOptions.responseType == ResponseType.stream) {
  //         // 处理流式请求
  //         final retryStreamResponse = await _retryRequest(response.requestOptions);
  //         return retryStreamResponse;
  //         // handler?.resolve(retryStreamResponse); // 返回新的流式响应
  //       } else {
  //         // 处理普通请求
  //         final retryResponse = await _retryRequest(response.requestOptions);
  //         handler?.resolve(retryResponse); // 返回新的响应
  //       }
  //     }
  //   } catch (e) {
  //     // 刷新 Token 失败，触发登出逻辑
  //     handleTokenRefreshFailed();
  //   }
  //   return null;
  // }

  // /// 处理 Token 刷新失败
  // static void handleTokenRefreshFailed() {
  //   // LogoutBusEvent().fire(); // 触发登出事件
  //   // xShowToast("登录已过期，请重新登录");
  // }

  /// 处理业务错误
  static void handleBusinessError(XBaseResp response) {
    if (response.message.isNotEmpty) {
      xShowToast(response.message);
    }
  }

  /// 处理 HTTP 错误
  static void handleHttpError(Response response) {
    xShowToast("HTTP 错误: ${response.statusCode}");
  }

  /// 处理意外的响应格式
  static void handleUnexpectedResponse(Response response) {
    xShowToast("意外的响应格式:${response.data}");
  }

  // /// 使用新的 Token 重新发起请求
  // static Future<Response> _retryRequest(RequestOptions requestOptions) async {
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //     responseType: requestOptions.responseType,
  //   );

  //   // 如果是流式请求，确保返回的是流式数据
  //   if (requestOptions.responseType == ResponseType.stream) {
  //     return XApiService.instance.dio.request<ResponseBody>(
  //       requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options,
  //     );
  //   }

  //   return XApiService.instance.dio.request(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }

  /// 异常处理
  static Object handleException(Object e, Object? stackTrace) {
    if (e is DioException) {
      if (e.response != null) {
        final resp = e.response!;

        if (resp.data is Map &&
            resp.data['error'] != null &&
            resp.statusCode != 402 &&
            resp.statusCode != 401) {
          return resp.data['error'] ?? e.toString();
        }

        if (resp.statusCode != null) {
          final ret = _resolveHTTPStatusCode(resp.statusCode!);
          if (ret != null) {
            return ret;
          }
        }

        return resp.statusMessage ?? e.toString();
      }

      if (_retryableErrors.contains(e.type)) {
        return '请求超时，请重试';
      }
    }

    return e.toString();
  }

  static Object? _resolveHTTPStatusCode(int statusCode) {
    return null;
  }

  static void printResponse(Response response) {
    final encoder = const JsonEncoder.withIndent('  ');
    if (kDebugMode) {
      // 打印请求接口信息
      debugPrint("\n****** HTTP RESPONSE **********************");
      var headers = response.requestOptions.headers;
      debugPrint("headers: ${encoder.convert(headers)}");
      debugPrint("Method: ${response.requestOptions.method}");
      debugPrint("Base URL: ${response.requestOptions.baseUrl}");
      debugPrint("Path: ${response.requestOptions.path}");
      var data = response.requestOptions.data;

      if (data is Map) {
        debugPrint("Body: ${jsonEncode(data)}");
      } else {
        debugPrint("Body: ${data.toString()}");
      }

      debugPrint("Status Code: ${response.statusCode}");
      if (response.data is! ResponseBody) {
        debugPrint(encoder.convert(response.data));
      }
      debugPrint("DateTime: ${DateTime.now()}");
      debugPrint("\n******************************************");
    }
  }

  static final List<DioExceptionType> _retryableErrors = [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  ];
}
