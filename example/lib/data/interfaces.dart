import 'package:common_module_flutter/osam.dart';
import 'package:common_module_flutter_example/model/language.dart';

abstract class OsamRepository {
  Future<VersionControlResponse> checkForUpdates();

  Future<RatingControlResponse> checkRating();
}

abstract class Settings {
  bool hasLanguage();

  Future<void> setLanguage(AppLanguage language);

  AppLanguage getLanguage();
}
