import 'dart:io' show Platform;

import 'package:common_module_flutter/internal/interfaces.dart';

class DevicePlatform extends Device {
  @override
  String getPlatformName() {
    String platform = "";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }
    return platform;
  }
}
