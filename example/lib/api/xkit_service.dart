import 'package:xkit/api/x_api_service.dart';

/// XKit API 服务
///
/// 使用工厂构造函数实现单例模式，确保线程安全
class XKitService extends XApiService {
  // 私有静态实例
  static final XKitService _instance = XKitService._internal();

  // 工厂构造函数
  factory XKitService() {
    return _instance;
  }

  // getter方法获取实例（可选，如果喜欢 instance 访问方式）
  static XKitService get instance => _instance;

  // 私有构造函数
  XKitService._internal() {
    // 初始化配置
    xdio.options.baseUrl = 'https://api.example.com/';

    // 添加拦截器（如果需要）
    xdio.interceptors.addAll(interceptors);
  }
}
