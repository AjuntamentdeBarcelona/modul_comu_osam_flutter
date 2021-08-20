import 'package:common_module_flutter/internal/remote/dto/Message.dart';
import 'package:common_module_flutter/internal/interfaces.dart';

class RateMe {
  final int minutesUntilInitialPrompt;
  final int minLaunchesUntilInitialPrompt;
  final String appStoreIdentifier;
  final Message message;
  ShowDialogResponse response = ShowDialogResponse.DONT_SHOW_DIALOG;

  RateMe({
    this.minutesUntilInitialPrompt = 0,
    this.minLaunchesUntilInitialPrompt = 0,
    this.appStoreIdentifier = "",
    this.message = const Message(),
  });

  String playStoreUrl(String packageName) {
    return "https://play.google.com/store/apps/details?id=$packageName";
  }
}
