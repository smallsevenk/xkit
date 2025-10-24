/*
 * 文件名称: x_request_interceptor.dart
 * 创建时间: 2025/10/22 16:31:21
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xkit/api/x_api_sign.dart';
import 'package:xkit/helper/x_app_device_info.dart';

class XRequestInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 在请求发起前修改头部
    //设置超时时间
    options.connectTimeout = Duration(seconds: connectTimeout);
    options.receiveTimeout = Duration(seconds: receiveTimeout);
    options.sendTimeout = Duration(seconds: sendTimeout);

    var adInfo = XAppDeviceInfo.instance;
    // token
    options.headers["Authorization"] = authorization;
    options.headers["App-Name"] = Uri.encodeComponent(adInfo.appName);
    options.headers["Bundle-Id"] = adInfo.packageName;
    options.headers["Device-ID"] = await adInfo.getDeviceId();
    options.headers["App-Version"] = adInfo.version;

    // 三方透传参数
    options.headers["App-Param"] = jsonEncode(appParam);

    // 设置请求的 Content-Type
    options.contentType = Headers.jsonContentType;

    debugPrint("\nURL: ${options.uri.toString()}");

    var sign = await XApiSign.sign(
      url: options.uri.toString(),
      method: options.method,
      bodyParams: options.data,
    );
    options.headers["X-Content-Security"] = sign;

    // 一定要加上这句话，否则进入不了下一步
    return handler.next(options);
  }

  // 获取授权信息
  String get authorization => '';

  int get connectTimeout => 120;

  int get receiveTimeout => 60;

  int get sendTimeout => 60;

  dynamic get appParam => {};
}
