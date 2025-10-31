/*
 * 文件名称: network.dart
 * 创建时间: 2025/07/08 19:49:27
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

// 检测网络状态
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkNetwork() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false; // 无网络连接
  }
  return true; // 有网络连接
}

/// 监听网络状态变化
void onNetworkChanged() {
  Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {});
}
