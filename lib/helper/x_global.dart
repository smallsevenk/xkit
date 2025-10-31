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
import 'package:xkit/x_kit.dart';

class XGlobal {
  // 单例模式
  static final XGlobal _instance = XGlobal._internal();
  factory XGlobal() => _instance;
  XGlobal._internal();

  /// 初始化全局属性
  static Future<void> init() async {
    await XSpUtil.init();
    await XAppDeviceInfo.instance.init();
  }
}

showToast(String? content, {int? animationTime, Object? stackTrace}) {
  content = content ?? '';

  if (content.isEmpty) return;

  BotToast.showText(
    text: content,
    align: Alignment.center,
    duration: Duration(seconds: animationTime ?? 2),
  );
}

xKeyboradHide() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

safeAreaBottomPadding(BuildContext context) {
  MediaQuery.of(context).padding.bottom;
}

loseFocus(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

/// 全局主题模式
String get themeMode => XSpUtil.prefs.getString('themeMode') ?? 'system';
set themeMode(String mode) {
  XSpUtil.prefs.setString('themeMode', mode);
}
