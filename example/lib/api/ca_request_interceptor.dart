/*
 * 文件名称: x_request_interceptor.dart
 * 创建时间: 2025/10/22 16:31:21
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:xkit/api/x_api_sign.dart';
import 'package:xkit/x_kit.dart';
// import 'package:flutter/services.dart' show rootBundle;

class CARequestInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 在请求发起前修改头部
    options.headers["Authorization"] = "Bearer authorization";

    // 三方透传参数
    options.headers["App-Param"] = jsonEncode({'appKey': 'appValue'});

    //  签名
    var publicKeyPem = await rootBundle.loadString('public.pem');
    var sign = await XApiSign.sign(
      url: options.uri.toString(),
      method: options.method,
      bodyParams: options.data,
      publicKeyPem: publicKeyPem,
    );
    options.headers["X-Content-Security"] = sign;

    // 一定要加上这句话，否则进入不了下一步
    return handler.next(options);
  }
}
