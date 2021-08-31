import 'dart:io';

import 'package:common_module_flutter/internal/device/DevicePlatform.dart';
import 'package:common_module_flutter/internal/rating/RateMePreferencesImpl.dart';
import 'package:common_module_flutter/internal/rating/model/RateMe.dart';
import 'package:common_module_flutter/internal/remote/Remote.dart';
import 'package:common_module_flutter/di/DI.dart';
import 'package:common_module_flutter/internal/version_control/VersionControlRepositoryImpl.dart';
import 'package:common_module_flutter/osam/src/VersionControlResponse.dart';
import 'package:common_module_flutter/internal/remote/dto/Message.dart';
import 'package:common_module_flutter/internal/remote/dto/Version.dart';
import 'package:common_module_flutter/internal/rating/RateMeRepositoryImpl.dart';
import 'package:common_module_flutter/internal/interfaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Strings.dart';

const Color confirmDialogTitleColor = Color(0xFF1C1C1C);
const Color confirmDialogMessageColor = Color(0xFF696973);
const Color confirmDialogCancelActionColor = Color(0xFF696973);
const Color confirmDialogConfirmActionColor = Color(0xFF0069E1);

class OSAM {
  late Remote _remote;
  late VersionControlRepository _versionControlRepository;
  late RateMeRepository _rateMeRepository;

  static const tagDialogVersionControl = "dialogVersionControl";

  OSAM(String token) {
    _remote = Remote(token);
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DevicePlatform devicePlatform = DevicePlatform();
    _versionControlRepository = VersionControlRepositoryImpl(
      _remote,
      devicePlatform,
    );
    _rateMeRepository = RateMeRepositoryImpl(
      _remote,
      RateMePreferencesImpl(prefs),
      devicePlatform,
    );
  }

  Future<VersionControlResponse> versionControl(
    BuildContext context, {
    required Language language,
  }) async {
    try {
      final versionResponse =
          await _versionControlRepository.getVersionControl();

      if (versionResponse.comparisonMode.isNone()) {
        return VersionControlResponse.NOT_NEEDED;
      }
      DI.tracker.trackVersionControlShown();

      Navigator.popUntil(
          context, (route) => route.settings.name != tagDialogVersionControl);

      final result = await showDialog(
        context: context,
        routeSettings: RouteSettings(name: tagDialogVersionControl),
        builder: (ctx) {
          return AlertDialog(
            title: Text(versionResponse.title.withLanguage(language)),
            content: Text(versionResponse.message.withLanguage(language)),
            actions: [
              TextButton(
                child: Text(
                  versionResponse.ok.withLanguage(language).toUpperCase(),
                ),
                onPressed: () {
                  DI.tracker.trackVersionControlAccepted();
                  String url = versionResponse.url;
                  if (versionResponse.comparisonMode.mustOpenStore() &&
                      url.isNotEmpty) {
                    _openExternalUrl(url);
                  }
                  Navigator.pop(ctx, VersionControlResponse.ACCEPTED);
                },
              ),
              if (versionResponse.comparisonMode.isLazy())
                TextButton(
                  child: Text(versionResponse.cancel
                      .withLanguage(language)
                      .toUpperCase()),
                  onPressed: () {
                    DI.tracker.trackVersionControlCancelled();
                    Navigator.pop(ctx, VersionControlResponse.CANCELLED);
                  },
                ),
            ],
          );
        },
        barrierDismissible: !versionResponse.comparisonMode.isForce(),
      );

      return result != null ? result : VersionControlResponse.DISMISSED;
    } catch (e) {
      return VersionControlResponse.ERROR;
    }
  }

  Future<RatingControlResponse> rating(
    BuildContext context, {
    required Language language,
  }) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appId = packageInfo.packageName;
      RateMe rateMe = await _rateMeRepository.getRateMe(appId, language);

      if (rateMe.response == ShowDialogResponse.DONT_SHOW_DIALOG) {
        return RatingControlResponse.NOT_NEEDED;
      }
      if (rateMe.response == ShowDialogResponse.ERROR) {
        return RatingControlResponse.ERROR;
      }

      DI.tracker.trackRatingShown();

      if (Platform.isIOS) {
        RateMyApp rateMyApp = RateMyApp(
          minDays: 0,
          minLaunches: 0,
          remindDays: 0,
          remindLaunches: 0,
          preferencesPrefix: 'rateMyApp_',
          googlePlayIdentifier: appId,
          appStoreIdentifier: rateMe.appStoreIdentifier,
        );
        rateMyApp.showRateDialog(
          context,
          ignoreNativeDialog: false,
        );
        await _rateMeRepository.handleAction(RateMeAction.DONT_RATE);
        return RatingControlResponse.HANDLED_BY_SYSTEM;
      } else {
        String appName = packageInfo.appName;
        return _showCustomRatingDialog(
            context, rateMe, language, appId, appName);
      }
    } catch (e) {
      return RatingControlResponse.ERROR;
    }
  }

  Future<RatingControlResponse> _showCustomRatingDialog(BuildContext context,
      RateMe rateMe, Language language, String appId, String appName) async {
    final RatingControlResponse? result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        appName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(rateMe.message.withLanguage(language),
                          style: TextStyle(
                            color: confirmDialogMessageColor,
                            fontSize: 17,
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text(
                                  Strings.getString(
                                          "rate_me_button_rate_now", language)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: confirmDialogConfirmActionColor,
                                      fontSize: 15)),
                              onPressed: () async {
                                DI.tracker.trackRatingAccepted();
                                String url = rateMe.playStoreUrl(appId);
                                await _rateMeRepository
                                    .handleAction(RateMeAction.RATE_NOW);
                                if (url.isNotEmpty) {
                                  _openExternalUrl(url);
                                }
                                Navigator.pop(
                                    context, RatingControlResponse.ACCEPTED);
                              },
                            ),
                            TextButton(
                              child: Text(
                                Strings.getString("rate_me_button_no", language)
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: confirmDialogConfirmActionColor,
                                    fontSize: 15),
                              ),
                              onPressed: () async {
                                DI.tracker.trackRatingCancelled();
                                await _rateMeRepository
                                    .handleAction(RateMeAction.DONT_RATE);
                                Navigator.pop(
                                  context,
                                  RatingControlResponse.CANCELLED,
                                );
                              },
                            ),
                            TextButton(
                              child: Text(
                                Strings.getString(
                                  "rate_me_button_later",
                                  language,
                                ).toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: confirmDialogConfirmActionColor,
                                    fontSize: 15),
                              ),
                              onPressed: () async {
                                DI.tracker.trackRatingLater();
                                await _rateMeRepository
                                    .handleAction(RateMeAction.RATE_LATER);
                                Navigator.pop(
                                  context,
                                  RatingControlResponse.CANCELLED,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    return result != null ? result : RatingControlResponse.DISMISSED;
  }

  Future<void> _openExternalUrl(String url) async {
    try {
      String parsedUri = Uri.parse(url).toString();
      if (await canLaunch(parsedUri)) {
        await launch(parsedUri, forceSafariVC: false);
      } else {
        print("Can't open. No installed app for URI");
      }
    } catch (uriException) {
      print("Can't open. Invalid URI");
    }
  }
}
