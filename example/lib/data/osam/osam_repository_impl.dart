import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/model/language.dart'
    as app_language;

class OsamRepositoryImpl extends OsamRepository {
  final OSAM osamSdk;
  final Settings settings;
  AlertWrapper? alertWrapper;

  Future<VersionControlResponse>? _checkForUpdatesFuture;
  Future<RatingControlResponse>? _checkRatingFuture;

  OsamRepositoryImpl(
    this.osamSdk,
    this.settings,
  );

  void setAlertWrapper(AlertWrapper wrapper) {
    alertWrapper = wrapper;
  }

  @override
  Future<VersionControlResponse> checkForUpdates() async {
    if (_checkForUpdatesFuture != null) {
      debugPrint("OsamRepository: already checking, waiting...");
      return _checkForUpdatesFuture!;
    }

    _checkForUpdatesFuture = _doCheckForUpdates();
    try {
      return await _checkForUpdatesFuture!;
    } finally {
      _checkForUpdatesFuture = null;
    }
  }

  Future<VersionControlResponse> _doCheckForUpdates() async {
    try {
      final language = _getLanguage(settings.getLanguage());
      final isDark =
          PlatformDispatcher.instance.platformBrightness == Brightness.dark;

      debugPrint(
          "OsamRepository: Requesting versionControl (lang: ${language.toLanguageCode()}, dark: $isDark)");

      if (alertWrapper != null) {
        return await alertWrapper!.showVersionControlNative(
          osam: osamSdk,
          language: language,
          isDarkMode: isDark,
        );
      }

      final response = await osamSdk.versionControl(
        language: language,
        isDarkMode: isDark,
      );

      debugPrint("OsamRepository: versionControl response = $response");
      return response;
    } catch (e) {
      debugPrint("OsamRepository: versionControl error = $e");
      return VersionControlResponse.ERROR;
    }
  }

  @override
  Future<RatingControlResponse> checkRating() async {
    if (_checkRatingFuture != null) {
      debugPrint("OsamRepository: already checking rating, waiting...");
      return _checkRatingFuture!;
    }

    _checkRatingFuture = _doCheckRating();
    try {
      return await _checkRatingFuture!;
    } finally {
      _checkRatingFuture = null;
    }
  }

  Future<RatingControlResponse> _doCheckRating() async {
    try {
      final language = _getLanguage(settings.getLanguage());
      final isDark =
          PlatformDispatcher.instance.platformBrightness == Brightness.dark;

      debugPrint(
          "OsamRepository: Requesting rating (lang: ${language.toLanguageCode()}, dark: $isDark)");

      if (alertWrapper != null) {
        return await alertWrapper!.showRating(
          osam: osamSdk,
          language: language,
          isDarkMode: isDark,
        );
      }

      final response = await osamSdk.rating(
        language: language,
        isDarkMode: isDark,
      );

      debugPrint("OsamRepository: rating response = $response");
      return response;
    } catch (e) {
      debugPrint("OsamRepository: rating error = $e");
      return RatingControlResponse.ERROR;
    }
  }

  Language _getLanguage(app_language.AppLanguage appLanguage) {
    switch (appLanguage) {
      case app_language.AppLanguage.ES:
        return Language.ES;
      case app_language.AppLanguage.CA:
        return Language.CA;
      case app_language.AppLanguage.EN:
        return Language.EN;
    }
  }

  @override
  Future<DeviceInformation> deviceInformation() => osamSdk.deviceInformation();

  @override
  Future<AppInformation> appInformation() => osamSdk.appInformation();

  @override
  Future<AppLanguageResponse> changeLanguageEvent() => osamSdk
      .changeLanguageEvent(language: _getLanguage(settings.getLanguage()));

  @override
  Future<AppLanguageResponse> firstTimeOrUpdateEvent() =>
      osamSdk.firstTimeOrUpdateAppEvent(
          language: _getLanguage(settings.getLanguage()));

  @override
  Future<SubscriptionResponse> subscribeToCustomTopic() =>
      osamSdk.subscribeToCustomTopic(topic: "TestTopic");

  @override
  Future<SubscriptionResponse> unsubscribeToCustomTopic() =>
      osamSdk.unsubscribeToCustomTopic(topic: "TestTopic");

  @override
  Future<TokenResponse> getFCMToken() => osamSdk.getFCMToken();
}
