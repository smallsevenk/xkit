/*
 * 文件名称: x_datetime_ext.dart
 * 创建时间: 2025/10/22 16:31:46
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

extension XDateTimeExt on DateTime {
  /// 格式化为 `yyyy-MM-dd` 格式
  String toDateString() {
    return "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  /// 格式化为 `HH:mm:ss` 格式
  String toTimeString() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
  }

  /// 格式化为 `HH:mm` 格式
  String toHHmmString() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}}";
  }

  /// 格式化为 `yyyy-MM-dd HH:mm:ss` 格式
  String toDateTimeString() {
    return "${toDateString()} ${toTimeString()}";
  }

  /// 格式化为 `MM-dd HH:mm` 格式
  String toShortDateTimeString() {
    return "${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  String get toAiDateStr {
    // 如果是当天显示 HH:mm，当年显示 MM-dd HH:mm，否则显示 yyyy-MM-dd HH:mm
    final now = DateTime.now();
    if (year == now.year && month == now.month && day == now.day) {
      return toHHmmString();
    } else if (year == now.year) {
      return toShortDateTimeString();
    } else {
      return "${toDateString()} ${toHHmmString()}";
    }
  }

  /// 转换为友好的时间显示（如 "刚刚", "5分钟前", "昨天", "2023-04-10"）
  String toFriendlyString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return "刚刚";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}分钟前";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}小时前";
    } else if (difference.inDays == 1) {
      return "昨天";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}天前";
    } else {
      return toHHmmString();
    }
  }
}
