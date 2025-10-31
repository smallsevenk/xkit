/*
 * 文件名称: x_api_service.dart
 * 创建时间: 2025/10/22 16:31:34
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:xkit/api/interceptor/x_error_interceptor.dart';
import 'package:xkit/api/interceptor/x_request_interceptor.dart';
import 'package:xkit/api/interceptor/x_response_interceptor.dart';
import 'package:xkit/api/x_base_resp.dart';
import 'package:xkit/helper/x_global.dart';
import 'package:xkit/helper/x_loading.dart';
import 'package:xkit/helper/x_logger.dart';
import 'package:xkit/helper/x_sp.dart';

class XApiService {
  Dio xdio = Dio();

  XApiService() {
    xdio.interceptors.addAll(interceptors);
  }

  List<Interceptor> get interceptors => [
    XRequestInterceptor(),
    XResponseInterceptor(),
    XErrorInterceptor(),
  ];

  /// GET 请求
  Future<T?> doGet<T>(
    String path,
    T Function(XBaseResp) parser, {
    Map<String, dynamic>? params,
    bool showLoading = false,
    bool mock = false,
    String? mockUrl,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Function(XBaseResp)? handleBusinessError,
  }) async {
    return _executeRequest(
      () => xdio.get(
        mock ? mockUrl! : path,
        data: params,
        options: getOptions(showLoading: showLoading, options: options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
      parser,
      showLoading: showLoading,
      handleBusinessError: handleBusinessError,
    );
  }

  /// POST 请求
  Future<T?> doPost<T>(
    String path,
    T Function(XBaseResp) parser, {
    Map<String, dynamic>? params,
    Object? data,
    bool showLoading = false,
    bool mock = false,
    String? mockUrl,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Function(XBaseResp)? handleBusinessError,
  }) async {
    return _executeRequest(
      () => xdio.post(
        mock ? mockUrl! : path,
        data: data ?? params,
        options: getOptions(showLoading: showLoading, options: options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      parser,
      showLoading: showLoading,
      handleBusinessError: handleBusinessError,
    );
  }

  /// 通用请求执行方法
  Future<T?> _executeRequest<T>(
    Future<Response> Function() request,
    T Function(XBaseResp) parser, {
    bool showLoading = false,
    Function(XBaseResp)? handleBusinessError,
  }) async {
    final startTime = DateTime.now(); // 记录请求开始时间
    try {
      if (showLoading) XLoading.show(status: '加载中...');

      final response = await request();

      if (showLoading) XLoading.dismiss();

      final endTime = DateTime.now(); // 记录请求结束时间
      final duration = endTime.difference(startTime); // 计算耗时
      debugPrint('接口耗时: ${duration.inMilliseconds} ms'); // 打印耗时
      final baseResp = XBaseResp.fromJson(response.data);
      _handleBusinessError(baseResp, businessError: handleBusinessError);
      return parser(baseResp);
    } catch (e) {
      if (showLoading) XLoading.dismiss();

      final endTime = DateTime.now(); // 记录请求结束时间（即使失败）
      final duration = endTime.difference(startTime); // 计算耗时
      debugPrint('接口耗时: ${duration.inMilliseconds} ms (失败)'); // 打印耗时

      _handleError(e);
      return null;
    }
  }

  /// 处理 Options
  Options getOptions({bool showLoading = false, Options? options}) {
    options ??= Options();
    options.extra ??= {};
    options.headers ??= {};
    options.extra!['showLoading'] = showLoading;
    return options;
  }

  /// 处理业务错误
  static void _handleBusinessError(XBaseResp response, {Function? businessError}) {
    if (!response.success) {
      // 业务错误处理
      if (businessError != null) {
        businessError();
      }
      if (response.message.isNotEmpty) {
        showToast(response.message);
      }
    }
  }

  Future<T?> uploadFile<T>(String path, String filePath, T Function(XBaseResp) parser) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('文件不存在: $filePath');
    }

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: file.uri.pathSegments.last),
    });

    final response = await doPost(
      path,
      parser,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response;
  }

  /// 处理错误
  void _handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          showToast('连接超时，请稍后重试');
          break;
        case DioExceptionType.receiveTimeout:
          showToast('接收超时，请稍后重试');
          break;
        case DioExceptionType.sendTimeout:
          showToast('发送超时，请稍后重试');
          break;
        case DioExceptionType.badResponse:
          showToast('服务器错误：${error.response?.statusCode}');
          break;
        case DioExceptionType.cancel:
          showToast('请求已取消');
          break;
        default:
          showToast('网络异常，请检查您的网络');
      }
    } else {
      showToast('未知错误：$error');
      xdp(error.toString());
    }
  }

  /// 非 Release 模式设置代理
  void setProxy() {
    if (XSpUtil.prefs.getBool('ProxyEnabled') ?? false) {
      xdio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient(context: SecurityContext(withTrustedRoots: false));
          client.findProxy = (uri) {
            var ip = XSpUtil.prefs.getString('ProxyAddress');
            return 'PROXY $ip'; // proxyIp: 代理ip，proxyPort：代理端口
          };
          client.badCertificateCallback = (X509Certificate cert, String host, int port) =>
              true; // 允许自签名证书
          return client;
        },
      );
    }
  }
}
