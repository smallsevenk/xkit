/*
 * 文件名称: x_loading.dart
 * 创建时间: 2025/10/22 16:32:08
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class XLoading {
  static int _loadingCount = 0; // 计数器，用于跟踪当前请求数量
  XLoading._() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..textColor = Color(0xFF1A1A1A)
      ..indicatorColor = Color(0xFF1A1A1A)
      ..radius = 8.0
      ..contentPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16)
      ..userInteractions = false;
  }

  /// 显示加载框
  static void show({String status = '加载中...'}) {
    _loadingCount++;
    if (_loadingCount == 1) {
      EasyLoading.show(status: status); // 只有第一个请求时显示 loading
    }
  }

  /// 关闭加载框
  static void dismiss() {
    if (_loadingCount > 0) {
      _loadingCount--;
      if (_loadingCount == 0) {
        EasyLoading.dismiss(); // 只有当所有请求完成时才关闭 loading
      }
    }
  }

  /// 显示成功提示
  static void showSuccess(String message) {
    _loadingCount = 0; // 重置计数器
    EasyLoading.showSuccess(message);
  }

  /// 显示错误提示
  static void showError(String message) {
    _loadingCount = 0; // 重置计数器
    EasyLoading.showError(message);
  }

  /// 显示信息提示
  static void showInfo(String message) {
    _loadingCount = 0; // 重置计数器
    EasyLoading.showInfo(message);
  }
}
