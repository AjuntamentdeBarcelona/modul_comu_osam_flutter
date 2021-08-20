import 'package:common_module_flutter/internal/device/DevicePlatform.dart';
import 'package:common_module_flutter/internal/remote/Remote.dart';
import 'package:common_module_flutter/osam/src/VersionControlResponse.dart';
import 'package:common_module_flutter/internal/remote/dto/Rating.dart';
import 'package:common_module_flutter/internal/interfaces.dart';
import 'package:get_version/get_version.dart';

import 'model/RateMe.dart';

class RateMeRepositoryImpl extends RateMeRepository {
  final Remote _remote;
  final RateMePreferences _rateMePreferences;
  final DevicePlatform _devicePlatform;

  RateMeRepositoryImpl(
    this._remote,
    this._rateMePreferences,
    this._devicePlatform,
  );

  @override
  Future<RateMe> getRateMe(
      String appId, Language language) async {
    int prefsVersion = _rateMePreferences.getVersionCode();
    int currentVersion = int.parse(await GetVersion.projectCode);
    if (prefsVersion != currentVersion) {
      // different version code:
      await _rateMePreferences.setVersionCode(currentVersion);
    }

    if (_rateMePreferences.getDontShowAgain()) {
      _rateMePreferences.setDontShowAgain(true);
      RateMe rateMe = RateMe();
      rateMe.response = ShowDialogResponse.DONT_SHOW_DIALOG;
      return rateMe;
    }

    Rating rating = await _remote.rating(appId, _devicePlatform.getPlatformName());

    RateMe rateMe = rating.toModel(language);
    rateMe.response = await _getRateMeResponse(rating);
    return rateMe;
  }

  Future<ShowDialogResponse> _getRateMeResponse(Rating rating) async {
    int totalLaunchCount = _rateMePreferences.getTotalLaunchCount() + 1;
    _rateMePreferences.setTotalLaunchCount(totalLaunchCount);

    int currentMillis = DateTime.now().millisecondsSinceEpoch;

    int timeOfAbsoluteFirstLaunch =
        _rateMePreferences.getTimeOfAbsoluteFirstLaunch();
    if (timeOfAbsoluteFirstLaunch == 0) {
      // this is the first launch!
      timeOfAbsoluteFirstLaunch = currentMillis;
      _rateMePreferences
          .setTimeOfAbsoluteFirstLaunch(timeOfAbsoluteFirstLaunch);
    }

    int timeOfLastPrompt = _rateMePreferences.getTimeOfLastPrompt();

    int launchesSinceLastPrompt =
        _rateMePreferences.getLaunchesSinceLastPrompt() + 1;
    _rateMePreferences.setLaunchesSinceLastPrompt(launchesSinceLastPrompt);

    ShowDialogResponse? showDialogResponse;
    bool showDialog = false;

    if (rating.minLaunchesUntilInitialPrompt > 0) {
      // if num_apert == 0 the popup is never shown

      if (totalLaunchCount >= rating.minLaunchesUntilInitialPrompt &&
          ((currentMillis - timeOfAbsoluteFirstLaunch)) >=
              (rating.minutesUntilInitialPrompt *
                  Duration(minutes: 1).inMilliseconds)) {
        // requirements for initial launch are met

        if (timeOfLastPrompt == 0 /* user was not yet shown a prompt */
            ||
            (launchesSinceLastPrompt >= rating.minLaunchesUntilInitialPrompt &&
                ((currentMillis - timeOfLastPrompt) >=
                    (rating.minutesUntilInitialPrompt *
                        Duration(minutes: 1).inMilliseconds)))) {
          _rateMePreferences.setTimeOfLastPrompt(currentMillis);
          _rateMePreferences.setLaunchesSinceLastPrompt(0);
          showDialog = true;
        }
      }

      if (showDialog) {
        showDialogResponse = ShowDialogResponse.SHOW_DIALOG;
      } else {
        showDialogResponse = ShowDialogResponse.DONT_SHOW_DIALOG;
      }
    }
    if (showDialogResponse == null) {
      showDialogResponse = ShowDialogResponse.ERROR;
    }
    return showDialogResponse;
  }

  @override
  Future<void> handleAction(RateMeAction rateMeAction) async {
    switch (rateMeAction) {
      case RateMeAction.RATE_NOW:
        await _rateMePreferences.setDontShowAgain(true);
        break;
      case RateMeAction.DONT_RATE:
        await _rateMePreferences.setDontShowAgain(true);
        break;
      case RateMeAction.RATE_LATER:
        await _rateMePreferences.setTotalLaunchCount(0);
        await _rateMePreferences.setLaunchesSinceLastPrompt(0);
        break;
    }
  }
}
