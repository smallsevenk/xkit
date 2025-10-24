/*
 * 文件名称: global.dart
 * 创建时间: 2025/04/12 08:43:26
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xkit/helper/x_sp.dart';

class XGlobal {
  // 单例模式
  static final XGlobal _instance = XGlobal._internal();
  factory XGlobal() => _instance;
  XGlobal._internal();

  /// 初始化全局属性
  static Future<void> init() async {}

  /// 全局主题模式
  static String get themeMode => XSpUtil.instance.prefs.getString('themeMode') ?? 'system';
  static set themeMode(String mode) {
    XSpUtil.instance.prefs.setString('themeMode', mode);
  }

  /// 全局语言设置
  static String get language => XSpUtil.instance.prefs.getString('language') ?? 'en';
  static set language(String lang) {
    XSpUtil.instance.prefs.setString('language', lang);
  }
}

xmKeyboradHide() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

safeAreaBottomPadding(BuildContext context) {
  MediaQuery.of(context).padding.bottom;
}
