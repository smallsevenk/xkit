/*
 * 文件名称: permission.dart
 * 创建时间: 2025/07/08 19:49:33
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xkit/helper/x_platform.dart';
import 'package:xkit/helper/x_sp.dart';
import 'package:xkit/widgets/x_alert.dart';

class XPermissionUtil {
  static String key = 'PermissionChecked';
  static String keyWin = 'PermissionCheckedWindow';

  /// 检查并请求麦克风权限
  static Future<bool> checkMicrophone({
    BuildContext Function()? context,
    Function()? showAlert,
  }) async {
    final status = await Permission.microphone.status;
    if (XPlatform.isAndroid() && !isPermissionGranted(status) && context != null) {
      // 在请求权限之前弹出自定义提示
      final agree = await _showRationaleDialog(
        context(),
        '请求权限',
        '为了提供 语音识别/语音输入 等功能，应用需要申请 麦克风 权限。请允许以继续使用相关功能。',
      );
      if (!agree) return false;
    }
    if (status.isGranted) return true;
    final result = await Permission.microphone.request();
    if (result.isGranted) return true;
    if (result.isPermanentlyDenied) {
      if (showAlert != null) {
        showAlert();
      } else if (context != null) {
        _showPermissionDialog(context, '麦克风');
      }
    }
    return false;
  }

  /// 检查并请求相机权限
  static Future<bool> checkCamera({BuildContext Function()? context, Function()? showAlert}) async {
    final status = await Permission.camera.status;
    if (XPlatform.isAndroid() && !isPermissionGranted(status) && context != null) {
      // 在请求权限之前弹出自定义提示
      final agree = await _showRationaleDialog(
        context(),
        '请求权限',
        '为了提供 拍照/视频通讯 等功能，应用需要申请 相机 权限。请允许以继续使用相关功能。',
      );
      if (!agree) return false;
    }
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      if (showAlert != null) {
        showAlert();
      } else if (context != null) {
        _showPermissionDialog(context, '相机');
      }
      return false;
    }
    final result = await Permission.camera.request();
    if (result.isGranted) return true;
    if (result.isPermanentlyDenied) {
      if (showAlert != null) {
        showAlert();
      } else if (context != null) {
        _showPermissionDialog(context, '相机');
      }
    }
    return false;
  }

  /// 检查并请求存储权限
  static Future<bool> checkStorage({
    BuildContext Function()? context,
    Function()? showAlert,
  }) async {
    final status = await Permission.storage.status;
    if (XPlatform.isAndroid() && !isPermissionGranted(status) && context != null) {
      // 在请求权限之前弹出自定义提示
      final agree = await _showRationaleDialog(
        context(),
        '请求权限',
        '为保存/读取文件（例如下载视频/图片等），应用需要申请 存储 权限。请允许以继续使用相关功能。',
      );
      if (!agree) return false;
    }
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      if (showAlert != null) {
        showAlert();
      } else if (context != null) {
        _showPermissionDialog(context, '存储');
      }
      return false;
    }
    final result = await Permission.storage.request();
    if (result.isGranted) return true;
    if (result.isPermanentlyDenied) {
      if (showAlert != null) {
        showAlert();
      } else if (context != null) {
        _showPermissionDialog(context, '存储');
      }
    }
    return false;
  }

  /// 检查语音识别请求权限
  static Future<bool> checkMicAndSpeeh({
    BuildContext Function()? context,
    Function()? showAlert,
  }) async {
    final status = await checkSinglePermission(Permission.microphone);
    bool ok = await XPermissionUtil.requestPermissions(
      [Permission.microphone, Permission.speech],
      context: context,
      permissionDesc: '语音识别/语音输入',
      isShowWindow: isPermissionGranted(status),
    );
    return ok;
  }

  /// 检查访问相册请求权限
  static Future<bool> checkPhotos(BuildContext Function() context) async {
    final status = await checkSinglePermission(Permission.photos);
    bool ok = await XPermissionUtil.requestPermissions(
      [Permission.photos],
      context: context,
      permissionDesc: '访问相册',
      isShowWindow: isPermissionGranted(status),
    );
    return ok;
  }

  /// 组合权限请求
  static Future<bool> requestPermissions(
    List<Permission> permissions, {
    BuildContext Function()? context,
    Function()? showAlert,
    String? permissionDesc,
    bool isShowWindow = true,
  }) async {
    Set checkedPermissions = (XSpUtil.prefs.getStringList(key) ?? []).toSet();
    List<String> waitCheckPermissions = permissions.map((e) => e.value.toString()).toList();
    bool firstCheck = !waitCheckPermissions.any((element) => checkedPermissions.contains(element));
    checkedPermissions.addAll(waitCheckPermissions);

    if (XPlatform.isAndroid() && !isShowWindow && context != null) {
      // 在请求权限之前弹出自定义提示
      final desc = permissionDesc ?? permissions.map((p) => _permissionName(p)).join('、');
      final agree = await _showRationaleDialog(
        context(),
        '请求权限',
        '为了提供 $desc 等功能，应用需要申请 ${_permissionName(permissions[0])} 权限。请允许以继续使用相关功能。',
      );
      if (!agree) return false;
    }

    // 先检查所有权限状态
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    // 保存已检查的权限列表
    XSpUtil.prefs.setStringList(key, checkedPermissions.toList().cast<String>());
    // 检查是否全部授权
    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (allGranted) return true;

    // 找到第一个被永久拒绝的权限
    Permission? deniedPerm;
    for (var entry in statuses.entries) {
      final status = entry.value;
      if (!status.isGranted) {
        deniedPerm = entry.key;
        break;
      }
    }

    if (deniedPerm != null && !firstCheck) {
      String name = _permissionName(deniedPerm);

      if (showAlert != null) {
        showAlert();
      } else if (context != null) {
        _showPermissionDialog(context, name.isNotEmpty ? name : (permissionDesc ?? '相关'));
      }
    }
    return false;
  }

  /// 权限类型转中文名
  static String _permissionName(Permission permission) {
    switch (permission) {
      case Permission.microphone:
        return '麦克风';
      case Permission.camera:
        return '相机';
      case Permission.storage:
        return '存储';
      case Permission.photos:
        return '相册';
      default:
        return '';
    }
  }

  /// 判断权限是否已开启
  static bool isPermissionGranted(PermissionStatus status) {
    return status.isGranted;
  }

  /// 检查单个权限状态
  static Future<PermissionStatus> checkSinglePermission(Permission permission) async {
    return await permission.status;
  }

  /// 通用权限弹窗
  static void _showPermissionDialog(BuildContext Function() context, String permissionName) {
    XAlert.show(
      context: context,
      content: '需要$permissionName权限才能正常使用该功能，请前往设置开启权限。',
      cancelText: '取消',
      confirmText: '去设置',
      onConfirm: () async {
        await openAppSettings();
      },
    );
  }

  /// 在请求权限前弹出用途说明，返回用户是否同意继续请求
  static Future<bool> _showRationaleDialog(BuildContext ctx, String title, String content) async {
    final result = await showDialog<bool>(
      context: ctx,
      barrierDismissible: true,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('允许')),
        ],
      ),
    );
    return result ?? false;
  }
}
