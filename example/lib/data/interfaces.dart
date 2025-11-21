import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:common_module_flutter_example/model/language.dart';

abstract class OsamRepository {
  Future<VersionControlResponse> checkForUpdates();

  Future<RatingControlResponse> checkRating();

  Future<DeviceInformation> deviceInformation();

  Future<AppInformation> appInformation();

  Future<LanguageInformationResponse> languageInformation();
}

abstract class Settings {
  bool hasLanguage();

  Future<void> setLanguage(AppLanguage language);

  AppLanguage getLanguage();
}
