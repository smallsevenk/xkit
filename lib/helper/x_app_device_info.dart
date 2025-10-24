/*
 * 文件名称: x_app_device_info.dart
 * 创建时间: 2025/10/22 17:12:40
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xkit/helper/x_logger.dart';
import 'package:xkit/helper/x_platform.dart';

class XAppDeviceInfo {
  // 单例模式
  static final XAppDeviceInfo _instance = XAppDeviceInfo._internal();
  factory XAppDeviceInfo() => _instance;
  static XAppDeviceInfo get instance => _instance;
  XAppDeviceInfo._internal();

  PackageInfo? _packageInfo;
  DeviceInfoPlugin? _deviceInfoPlugin;

  // 初始化方法（异步）
  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _deviceInfoPlugin = DeviceInfoPlugin();
    } catch (e) {
      xdp('App信息初始化失败: $e');
    }
  }

  // App基础信息
  String get appName => _packageInfo?.appName ?? 'Unknown';
  String get packageName => _packageInfo?.packageName ?? 'Unknown';
  String get version => _packageInfo?.version ?? '1.0.0';
  String get buildNumber => _packageInfo?.buildNumber ?? '1';

  // 设备信息（按需扩展）
  DeviceInfoPlugin? get deviceInfoPlugin {
    return _deviceInfoPlugin;
  }

  Future<String> getDeviceId() async {
    var deviceId = '';
    if (XPlatform.isAndroid()) {
      deviceId = (await getAndroidDeviceId()) ?? 'Unknown';
    } else if (XPlatform.isIOS()) {
      deviceId = (await getIosDeviceId()) ?? 'Unknown';
    }
    return deviceId;
  }

  // 获取 Android 设备 ID
  Future<String?> getAndroidDeviceId() async {
    try {
      final androidInfo = await _deviceInfoPlugin?.androidInfo;
      return androidInfo?.device; // 返回 Android 唯一标识符
    } catch (e) {
      xdp('获取 Android 设备 ID 失败: $e');
      return null;
    }
  }

  // 获取 iOS 设备 ID
  Future<String?> getIosDeviceId() async {
    try {
      final iosInfo = await _deviceInfoPlugin?.iosInfo;
      return iosInfo?.identifierForVendor; // 返回 iOS 唯一标识符
    } catch (e) {
      xdp('获取 iOS 设备 ID 失败: $e');
      return null;
    }
  }
}
