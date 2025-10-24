/*
 * 文件名称: x_widget_ext.dart
 * 创建时间: 2025/10/22 16:32:01
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:flutter/material.dart';

extension XWidgetExt on Widget {
  Widget onTap(Function()? onTapCallback) {
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTapCallback, child: this);
  }

  Widget inBox({Color? color}) {
    return Container(padding: EdgeInsets.all(0), color: color ?? Colors.red, child: this);
  }
}
