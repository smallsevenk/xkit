/*
 * 文件名称: x_sp.dart
 * 创建时间: 2025/10/22 17:09:53
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class XSpUtil {
  // 单例模式
  static final XSpUtil _instance = XSpUtil._internal();
  factory XSpUtil() => _instance;
  static XSpUtil get instance => _instance;
  XSpUtil._internal();

  /// 初始化全局属性
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // 数据库连接
    // _db = await DataBaseManager.openDataBase();
  }

  /// 获取 SharedPreferences 实例
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("Global.init() must be called before accessing prefs.");
    }
    return _prefs!;
  }

  /// SharedPreferences 实例
  static SharedPreferences? _prefs;

  // 保存字典
  static Future<bool> saveMap(String key, Map<String, dynamic> map) async {
    try {
      String jsonString = jsonEncode(map);
      return await XSpUtil.instance.prefs.setString(key, jsonString);
    } catch (e) {
      print('保存字典失败: $e');
      return false;
    }
  }

  // 读取字典
  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      String? jsonString = XSpUtil.instance.prefs.getString(key);
      if (jsonString != null) {
        Map<String, dynamic> dictionary = jsonDecode(jsonString);
        return dictionary;
      }
      return {};
    } catch (e) {
      print('读取字典失败: $e');
      return {};
    }
  }
}
