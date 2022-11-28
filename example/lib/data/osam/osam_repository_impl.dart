import 'package:common_module_flutter/model/app_information.dart';
import 'package:common_module_flutter/model/device_information.dart';
import 'package:common_module_flutter/osam.dart';
import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/model/language.dart'
    as AppLanguage;

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

  Language _getLanguage(AppLanguage.AppLanguage appLanguage) {
    Language language;
    switch (appLanguage) {
      case AppLanguage.AppLanguage.ES:
        language = Language.ES;
        break;
      case AppLanguage.AppLanguage.CA:
        language = Language.CA;
        break;
      case AppLanguage.AppLanguage.EN:
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
}
