import 'package:xkit_example/api/ca_api_service.dart';

class TestService {
  final Service _api = Service.instance; // 获取 ApiService 单例

  /// 同步用户信息
  Future<void> syncUserInfo() async {
    const path = '/auth/login';
    const mockUrl =
        'https://mock.apipost.net/mock/41fae66ff8e0000/auth/signByPhone?apipost_id=1faea0107b9002';

    // await UserManager().clearUserInfo();
    // 调用接口
    await _api.doPost(path, mock: false, mockUrl: mockUrl, showLoading: false, (resp) => resp);
  }

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
