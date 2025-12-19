import 'package:common_module_flutter_example/model/language.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';

abstract class OsamRepository {
  Future<VersionControlResponse> checkForUpdates();

  Future<RatingControlResponse> checkRating();

  Future<DeviceInformation> deviceInformation();

  Future<AppInformation> appInformation();

  Future<AppLanguageResponse> changeLanguageEvent();

  Future<AppLanguageResponse> firstTimeOrUpdateEvent();

  Future<SubscriptionResponse> subscribeToCustomTopic();

  Future<SubscriptionResponse> unsubscribeToCustomTopic();

  Future<TokenResponse> getFCMToken();
}

abstract class Settings {
  bool hasLanguage();

  Future<void> setLanguage(AppLanguage language);

  AppLanguage getLanguage();

  bool hasShowRatingPopup();

  bool getShowRatingPopup();

  Future<void> setShowRatingPopup(bool needTo);

  bool hasShowVersionControlPopup();

  bool getShowVersionControlPopup();

  Future<void> setShowVersionControlPopup(bool needTo);

  String getAppVersionName();

  Future<void> setAppVersionName(String appVersionName);

  String getAppVersionCode();

  Future<void> setAppVersionCode(String appVersionCode);

  List<String> getSubscribedTopics();

  Future<void> addSubscribedTopic(String topic);

  Future<void> removeSubscribedTopic(String topic);

  String getPopupMode();

  Future<void> setPopupMode(String mode);

  Stream<List<String>> getSubscribedTopicsStream();
}
