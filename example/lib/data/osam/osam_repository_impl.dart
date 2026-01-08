import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/model/language.dart'
    as app_language;

class OsamRepositoryImpl extends OsamRepository {
  final OSAM osamSdk;
  final Settings settings;

  OsamRepositoryImpl(
    this.osamSdk,
    this.settings,
  );

  @override
  Future<VersionControlResponse> checkForUpdates() async {
    return osamSdk.versionControl(
      language: _getLanguage(settings.getLanguage()),
    );
  }

  @override
  Future<RatingControlResponse> checkRating() async {
    return osamSdk.rating(language: _getLanguage(settings.getLanguage()));
  }

  Language _getLanguage(app_language.AppLanguage appLanguage) {
    Language language;
    switch (appLanguage) {
      case app_language.AppLanguage.ES:
        language = Language.ES;
        break;
      case app_language.AppLanguage.CA:
        language = Language.CA;
        break;
      case app_language.AppLanguage.EN:
        language = Language.EN;
        break;
      default:
        language = Language.CA;
        break;
    }
    return language;
  }

  @override
  Future<DeviceInformation> deviceInformation() {
    return osamSdk.deviceInformation();
  }

  @override
  Future<AppInformation> appInformation() {
    return osamSdk.appInformation();
  }

  @override
  Future<AppLanguageResponse> changeLanguageEvent() {
    return osamSdk.changeLanguageEvent(
      language: _getLanguage(settings.getLanguage()),
    );
  }

  @override
  Future<AppLanguageResponse> firstTimeOrUpdateEvent() {
    return osamSdk.firstTimeOrUpdateAppEvent(
      language: _getLanguage(settings.getLanguage()),
    );
  }

  @override
  Future<SubscriptionResponse> subscribeToCustomTopic() {
    return osamSdk.subscribeToCustomTopic(topic: "TestTopic");
  }

  @override
  Future<SubscriptionResponse> unsubscribeToCustomTopic() {
    return osamSdk.unsubscribeToCustomTopic(topic: "TestTopic");
  }

  @override
  Future<TokenResponse> getFCMToken() {
    return osamSdk.getFCMToken();
  }
}
