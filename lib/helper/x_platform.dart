/*
 * 文件名称: x_platform.dart
 * 创建时间: 2025/10/22 17:14:39
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:io';

import 'package:flutter/foundation.dart';

class XPlatform {
  static bool isDesktop() {
    return isWindows() || isLinux() || isMacOS();
  }

  static bool isDesktopAndWeb() {
    return isDesktop() || isWeb();
  }

  static bool isMobile() {
    return isIOS() || isAndroid();
  }

  static bool isIOS() {
    try {
      return Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  static bool isAndroid() {
    try {
      return Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMacOS() {
    try {
      return Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  static bool isWindows() {
    try {
      return Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  static bool isLinux() {
    try {
      return Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  static String operatingSystem() {
    try {
      return Platform.operatingSystem;
    } catch (e) {
      return 'unknown';
    }
  }

  static String operatingSystemVersion() {
    try {
      return Platform.operatingSystemVersion;
    } catch (e) {
      return 'unknown';
    }
  }

  static String localeName() {
    try {
      return Platform.localeName;
    } catch (e) {
      return 'zh_Hans_CN';
    }
  }
}
