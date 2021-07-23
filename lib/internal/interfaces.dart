import 'package:common_module_flutter/internal/remote/dto/Version.dart';
import 'package:common_module_flutter/osam/OSAM.dart';
import 'package:common_module_flutter/internal/rating/model/RateMe.dart';
abstract class VersionControlRepository {
  Future<Version> getVersionControl();
}
abstract class RateMeRepository {
  Future<RateMe> getRateMe(
    String appId,
    Language language,
  );
  Future<void> handleAction(RateMeAction rateMeAction);
}

abstract class Device {
  String getPlatformName();
}

abstract class RateMePreferences {
  Future<void> clearAll();

  Future<void> setTotalLaunchCount(int totalLaunchCount);

  int getTotalLaunchCount();

  Future<void> setTimeOfAbsoluteFirstLaunch(int timeAbsoluteFirstLaunch);

  int getTimeOfAbsoluteFirstLaunch();

  Future<void> setLaunchesSinceLastPrompt(int launchesSinceLastPrompt);

  int getLaunchesSinceLastPrompt();

  Future<void> setTimeOfLastPrompt(int timeOfLastPrompt);

  int getTimeOfLastPrompt();

  Future<void> setVersionCode(int versionCode);

  int getVersionCode();

  Future<void> setDontShowAgain(bool dontShowAgain);

  bool getDontShowAgain();
}

enum ShowDialogResponse { ERROR, DONT_SHOW_DIALOG, SHOW_DIALOG }

enum RateMeAction { RATE_NOW, DONT_RATE, RATE_LATER }
