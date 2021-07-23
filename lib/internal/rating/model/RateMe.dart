import 'package:common_module_flutter/internal/remote/dto/Message.dart';
import 'package:common_module_flutter/internal/interfaces.dart';

class RateMe {
  final int minutesUntilInitialPrompt;
  final int minLaunchesUntilInitialPrompt;
  final String appStoreIdentifier;
  final Message message;
  ShowDialogResponse response;

  RateMe({
    this.minutesUntilInitialPrompt,
    this.minLaunchesUntilInitialPrompt,
    this.appStoreIdentifier,
    this.message,
  });

  String playStoreUrl(String packageName) {
    return "https://play.google.com/store/apps/details?id=$packageName";
  }
}
