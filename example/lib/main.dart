import 'package:flutter/material.dart';
import 'package:xkit/x_kit.dart';
import 'package:xkit_example/api/test_srv.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  XGlobal.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('zh', 'CN'), // 中文
      //   const Locale('en', 'US'), // 英文
      // ],
      // locale: const Locale('zh', 'CN'), // 默认语言设置为中文
      builder: EasyLoading.init(
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent, // 关键属性，允许穿透点击‌
            onTap: () {
              // 关闭所有焦点键盘
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(XPlatform.isDesktop() ? 0.95 : 1)),
              child: BotToastInit()(context, child),
            ),
          );
        },
        // 这里设置了全局字体固定大小，不随系统设置变更
      ),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent, // 关键属性，允许穿透点击‌
        onTap: () {
          // 关闭所有焦点键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(title: Text('XKitDemo')),
          body: _buildList(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      children: <Widget>[
        _buildRow(
          'sendCode',
          onTap: () {
            // TestService().sendSmsCode('13800138000').then((value) {
            //   debugPrint('短信验证码发送结果: $value');
            // });

            TestService().syncUserInfo().then((value) {
              debugPrint('同步用户信息完成');
            });
          },
        ),
      ],
    );
  }

  Widget _buildRow(String title, {Function()? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50, child: Text(title, style: TextStyle(fontSize: 20))).onTap(onTap),
      ],
    );
  }
}
