import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:common_module_flutter_example/model/language.dart';
import 'package:osam_common_module_flutter/src/model/subscription_response.dart';
import 'package:osam_common_module_flutter/src/model/token_response.dart';


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
}
