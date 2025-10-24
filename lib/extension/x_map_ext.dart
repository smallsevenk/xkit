/*
 * 文件名称: x_map_ext.dart
 * 创建时间: 2025/10/22 16:31:51
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

extension XSafeMapExtension on Map<String, dynamic> {
  /// 获取字符串值
  String getString(String key, {String defaultValue = '', bool isTrim = false}) {
    final value = this[key];
    if (value is String) {
      return isTrim ? (value.trim().isNotEmpty ? value : defaultValue) : value;
    } else if (value != null) {
      return value.toString();
    }
    return defaultValue;
  }

  /// 获取整数值
  int getInt(String key, {int defaultValue = 0}) {
    final value = this[key];
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 获取双精度浮点值
  double getDouble(String key, {double defaultValue = 0.0}) {
    final value = this[key];
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 获取布尔值
  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    if (value is bool) {
      return value;
    } else if (value is String) {
      final lowerValue = value.toLowerCase();
      if (lowerValue == 'true' || lowerValue == '1') {
        return true;
      } else if (lowerValue == 'false' || lowerValue == '0') {
        return false;
      }
    }
    return defaultValue;
  }

  /// 获取列表值
  List<T> getList<T>(String key, {List<T> defaultValue = const []}) {
    final value = this[key];
    if (value is List) {
      return value.cast<T>();
    }
    return defaultValue;
  }

  /// 获取 Map 值
  Map<K, V> getMap<K, V>(String key, {Map<K, V> defaultValue = const {}}) {
    final value = this[key];
    if (value is Map) {
      return value.cast<K, V>();
    }
    return defaultValue;
  }

  /// 格式化 URL，将 POST 和 GET 请求以 GET 链接输出
  String get formattedUrl {
    return entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}').join('&');
  }
}
