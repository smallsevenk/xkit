/*
* 文件名称: error_interceptor.dart
* 创建时间: 2025/04/10 10:38:01
* 作者名称: Andy.Zhao
* 联系方式: smallsevenk@vip.qq.com
* 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
* 功能描述:  
*/

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:xkit/helper/x_global.dart';
import 'package:xkit/helper/x_loading.dart';
import 'package:xkit/helper/x_logger.dart';
import 'dart:convert';

class XErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      debugPrintError(err); // 打印错误信息
      if ([
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionTimeout,
      ].contains(err.type)) {
        showToast('连接超时,请重试');
      } else if (err.type == DioExceptionType.cancel) {
        xdp('请求已取消: ${err.requestOptions.uri}');
      } else {
        showToast("网络信号异常,请检查您的网络");
      }
      handler.next(err); // 继续传递错误
    } catch (e) {
      // 确保在错误情况下关闭 loading
      if (err.requestOptions.extra['showLoading'] == true) {
        XLoading.dismiss();
      }
      showToast("请求错误: ${e.toString()}");
    }
  }

  // 打印错误信息
  void debugPrintError(DioException err) {
    try {
      final encoder = const JsonEncoder.withIndent('  ');
      var headers = err.requestOptions.headers;
      debugPrint("headers: ${encoder.convert(headers)}");
      debugPrint('''      --- HTTP ERROR ---
      URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}
      Method: ${err.requestOptions.method}
      Status Code: ${err.response?.statusCode}
      Error Type: ${err.type}
      Error Message: ${err.message}
      
      Response Data: ${err.response?.data})
      --------------------''');
    } catch (e) {
      debugPrint('Error while printing Dio error: $e');
    }
  }
}
