/*
 * 文件名称: x_environment.dart
 * 创建时间: 2025/10/29 11:27:51
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:xkit/helper/x_global.dart';
import 'package:xkit/helper/x_sp.dart';

class CSEvn {
  static String envKey = 'XMCSEnvInfo'; // 环境信息的键
  static CSEnvResp get info {
    final jsonStr = XSpUtil.prefs.getString(envKey) ?? '';

    return jsonStr.isEmpty ? environments[0] : CSEnvResp.fromJson(jsonDecode(jsonStr));
  }

  static setEnv(CSEnvResp resp) {
    XSpUtil.prefs.setString(envKey, jsonEncode(resp.toJson()));
  }

  static setTel(String code) {
    XSpUtil.prefs.setString('XMTel', code);
  }

  static String get tel {
    return XSpUtil.prefs.getString('XMTel') ?? '';
  }

  static bool get auto {
    return tel.isNotEmpty;
  }
}

class CSEnvResp {
  int? id;
  String name;
  String url;
  int? codeTime;

  CSEnvResp(this.name, this.url, this.id, {this.codeTime = 5});

  CSEnvResp.fromJson(Map<String, dynamic> json)
    : name = json['name'] ?? '',
      url = json['url'] ?? '' {
    id = json['id'];
    codeTime = json['codeTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

final List<CSEnvResp> environments = [
  // CSEnvResp('生产', CSApiConfig.proBaseUrl, 0, codeTime: 60),
  // CSEnvResp('开发', CSApiConfig.devBaseUrl, 1),
  // CSEnvResp('测试', CSApiConfig.testBaseUrl, 2),
  CSEnvResp('自定义', '', 3),
]; // 环境列表

class XEnvironmentPage extends StatefulWidget {
  const XEnvironmentPage({super.key});

  @override
  State<XEnvironmentPage> createState() => _XEnvironmentPageState();
}

class _XEnvironmentPageState extends State<XEnvironmentPage> {
  final int _currEnvIdx = CSEvn.info.id ?? 0; // 当前选中的环境
  bool _isProxyEnabled = false; // 是否启用代理
  late TextEditingController _proxyController; // 代理地址输入框控制器

  late TextEditingController _customEnvController; // 自定义环境输入框控制器

  @override
  void initState() {
    super.initState();
    _customEnvController = TextEditingController(text: environments[3].url); // 自定义环境输入框控制器
    _proxyController = TextEditingController(
      text: XSpUtil.prefs.getString('ProxyAddress') ?? '',
    ); // 初始化代理地址
    _isProxyEnabled = XSpUtil.prefs.getBool('ProxyEnabled') ?? false; // 初始化代理开关状态
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF191919),
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () {
            CSEvn.setTel('18888888888');
            setState(() {});
          },
          child: const Text('环境切换', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onLongPress: () {
            //     CSEvn.setTel('17375772427');
            //     setState(() {});
            //   },
            // ),
            // Gap(16.h),
            // ...environments.map((env) => _buildEnvironmentOption(env)),
            // if (_currEnvIdx == 3) ...[
            //   Gap(16.h),
            //   TextField(
            //     controller: _customEnvController,
            //     decoration: InputDecoration(labelText: '自定义环境地址', border: OutlineInputBorder()),
            //     style: TextStyle(color: Colors.red),
            //   ),
            // ],
            // Gap(16.h),
            _buildProxySettings(),
            const Spacer(),
            SafeArea(
              child: Column(
                children: [
                  // ElevatedButton(
                  //   onPressed: _pushLoglist,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //     minimumSize: Size(double.infinity, 88.h),
                  //   ),
                  //   child: const Text(
                  //     '日志记录',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Gap(20.h),
                  ElevatedButton(
                    onPressed: _applyEnvironment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 88.h),
                    ),
                    child: const Text(
                      '应用环境',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildEnvironmentOption(CSEnvResp env) {
  //   return ListTile(
  //     title: Text(
  //       env.name,
  //       style: TextStyle(
  //         color: environments[_currEnvIdx].name == env.name ? Colors.red : Colors.white,
  //       ),
  //     ),
  //     subtitle:
  //         env.id != 3
  //             ? Text(
  //               env.url,
  //               style: TextStyle(
  //                 color: environments[_currEnvIdx].name == env.name ? Colors.red : Colors.white,
  //               ),
  //             )
  //             : null,
  //     onTap: () {
  //       setState(() {
  //         _currEnvIdx = env.id ?? 0;
  //       });
  //     },
  //   );
  // }

  Widget _buildProxySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '代理设置',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        Gap(16.h),
        SwitchListTile(
          title: const Text('启用代理', style: TextStyle(color: Colors.white)),
          value: _isProxyEnabled,
          onChanged: (value) {
            setState(() {
              _isProxyEnabled = value;
            });
          },
        ),
        if (_isProxyEnabled)
          TextField(
            controller: _proxyController,
            decoration: InputDecoration(labelText: '代理地址', border: OutlineInputBorder()),
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }

  void _applyEnvironment() {
    String selectedEnv = environments[_currEnvIdx].url;
    if (_currEnvIdx == 3) {
      selectedEnv = _customEnvController.text.trim();
      if (selectedEnv.isEmpty) {
        showToast('请输入自定义环境地址');
        return;
      }
    }

    // 保存环境和代理设置
    XSpUtil.prefs.setString(CSEvn.envKey, jsonEncode(environments[_currEnvIdx].toJson()));
    XSpUtil.prefs.setBool('ProxyEnabled', _isProxyEnabled);
    if (_isProxyEnabled) {
      XSpUtil.prefs.setString('ProxyAddress', '${_proxyController.text.trim()}:8888');
    } else {
      XSpUtil.prefs.remove('ProxyAddress'); // 如果未启用代理，清除代理地址
    }

    // 提示用户环境已切换
    showToast('环境已切换到: $selectedEnv');
    Navigator.pop(context);
  }

  // _pushLoglist() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => const CSLogListPage()));
  // }
}
