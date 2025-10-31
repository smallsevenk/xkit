/*
 * 文件名称: x_api_sign.dart
 * 创建时间: 2025/10/22 16:31:39
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:crypto/crypto.dart';

String key = "q4t7w!z%C*F-JaNdRgUjXn2r5u8x/A?D";

class XApiSign {
  static Future<String> sign({
    required String url,
    required String method,
    required String publicKeyPem,
    Map<String, dynamic>? bodyParams,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String content = [
      "version=v1",
      "type=0",
      "key=${base64UrlEncode(utf8.encode(key))}",
      "time=$timestamp",
    ].join("; ");

    String secret;
    try {
      // 创建RSA加密器
      final parser = RSAKeyParser();
      final publicKey = parser.parse(publicKeyPem) as RSAPublicKey;
      final encrypter = Encrypter(RSA(publicKey: publicKey));

      // 执行加密并Base64编码
      final encrypted = encrypter.encrypt(content);
      secret = base64Encode(encrypted.bytes);
    } catch (e) {
      return "";
    }

    // 1. 计算请求体SHA256哈希
    String body;
    if (bodyParams == null) {
      body = "";
    } else {
      body = jsonEncode(bodyParams);
    }
    final bodySign = sha256.convert(utf8.encode(body)).toString();

    // 2. 解析URL组件
    final uri = Uri.parse(url);
    final path = uri.path;
    final query = uri.query;

    // 3. 构建待签名字符串
    final t = timestamp.toString();
    final contentOfSign = [t, method, path, query, bodySign].join('\n');

    // 4. 生成HMAC-SHA256签名(Base64编码)
    final hmac = Hmac(sha256, utf8.encode(key));
    final signature = base64.encode(hmac.convert(utf8.encode(contentOfSign)).bytes);
    final params = ['key=$key', 'secret=$secret', 'signature=$signature'].join(';');

    // 调试输出(可选)
    // dp('X-Content-Security:=========:$params');

    return params;
  }
}
