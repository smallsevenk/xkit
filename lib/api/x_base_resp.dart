/*
 * 文件名称: x_base_resp.dart
 * 创建时间: 2025/10/22 16:34:21
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:xkit/extension/x_map_ext.dart';

class XBaseResp<T> {
  int code;
  String message;
  T? data;

  XBaseResp({required this.code, required this.message, this.data});

  factory XBaseResp.fromJson(Map<String, dynamic> json) {
    return XBaseResp(
      code: json.getInt('code'),
      message: json.getString('message'),
      data: json['data'],
    );
  }

  //   // 请求成功判断逻辑（兼容原 `isSuccess` 逻辑）
  bool get success => code == 200;

  bool get refreshToken => code == 100003;

  bool get refreshTokenFailed => code == 100008;
}
