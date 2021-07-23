import 'package:common_module_flutter/osam/OSAM.dart';
import 'package:example/model/language.dart' as AppLanguage;

import 'package:example/data/interfaces.dart';
import 'package:flutter/widgets.dart';

class OsamRepositoryImpl extends OsamRepository {
  final OSAM osamSdk;
  final Settings settings;

  OsamRepositoryImpl(
    this.osamSdk,
    this.settings,
  );

  Future<VersionControlResponse> checkForUpdates(BuildContext context) async {
    return osamSdk.versionControl(
      context,
      language: _getLanguage(settings.getLanguage()),
    );
  }

  @override
  Future<RatingControlResponse> checkRating(BuildContext context) async {
    return osamSdk.rating(context,
        language: _getLanguage(settings.getLanguage()));
  }

  Language _getLanguage(AppLanguage.AppLanguage appLanguage) {
    Language language;
    switch (appLanguage) {
      case AppLanguage.AppLanguage.ES:
        language = Language.ES;
        break;
      case AppLanguage.AppLanguage.CA:
      default:
        language = Language.CA;
        break;
    }
    return language;
  }
}
