// import 'package:flutter_test/flutter_test.dart';
// import 'package:xkit/xkit.dart';
// import 'package:xkit/xkit_platform_interface.dart';
// import 'package:xkit/xkit_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockXkitPlatform
//     with MockPlatformInterfaceMixin
//     implements XkitPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final XkitPlatform initialPlatform = XkitPlatform.instance;

//   test('$MethodChannelXkit is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelXkit>());
//   });

//   test('getPlatformVersion', () async {
//     Xkit xkitPlugin = Xkit();
//     MockXkitPlatform fakePlatform = MockXkitPlatform();
//     XkitPlatform.instance = fakePlatform;

//     expect(await xkitPlugin.getPlatformVersion(), '42');
//   });
// }
