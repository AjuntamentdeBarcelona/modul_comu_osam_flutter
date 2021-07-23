import 'package:common_module_flutter/osam/OSAM.dart';
import 'package:example/model/language.dart';
import 'package:flutter/widgets.dart';

abstract class OsamRepository {
  Future<VersionControlResponse> checkForUpdates(BuildContext context);

  Future<RatingControlResponse> checkRating(BuildContext context);
}

abstract class Settings {
  bool hasLanguage();

  Future<void> setLanguage(AppLanguage language);

  AppLanguage getLanguage();
}
