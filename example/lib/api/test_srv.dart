import 'package:xkit/x_kit.dart';
import 'package:xkit_example/api/xkit_service.dart';

class TestService {
  final XKitService _api = XKitService.instance; // 获取 ApiService 单例

  Future<String> sendSmsCode(String phone, {bool loginOrRegister = true}) async {
    const path = '/auth/sendSmsCode';
    const mockUrl =
        'https://mock.apipost.net/mock/41fae66ff8e0000/auth/sendSmsCode?apipost_id=1fb02aedfb900a';
    var params = {
      "phone": phone, //必填
      "scene": loginOrRegister ? "loginOrRegister" : "deleteAccount",
    };

    final code = await _api.doPost(
      path,
      params: params,
      mock: true,
      mockUrl: mockUrl,
      showLoading: true,
      (resp) => resp.data['code'] ?? '',
    );
    return code ?? '';
  }
}
