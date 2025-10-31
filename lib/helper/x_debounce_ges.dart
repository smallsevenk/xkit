import 'package:flutter/material.dart';

/// 通用防抖GestureDetector
class XDebounceGestureDetector extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final int debounceMilliseconds;
  static int _lastTapTimestamp = 0;

  const XDebounceGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.debounceMilliseconds = 800,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (onTap != null && now - _lastTapTimestamp > debounceMilliseconds) {
          _lastTapTimestamp = now;
          onTap!();
        }
      },
      child: child,
    );
  }
}
