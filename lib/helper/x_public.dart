/*
 * 文件名称: x_public.dart
 * 创建时间: 2025/10/22 16:32:15
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

xShowToast(String? content, {int? animationTime, Object? stackTrace}) {
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
