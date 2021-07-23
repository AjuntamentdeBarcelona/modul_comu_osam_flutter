import 'package:common_module_flutter/osam/OSAM.dart';
import 'package:example/data/interfaces.dart';
import 'package:example/data/settings/app_preferences.dart';
import 'package:example/data/osam/osam_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _osamSdk.init();
  }

  static OSAM _osamSdk = OSAM("b3NhbTpvc2Ft");
  static final Settings settings = AppPreferences(_prefs);
  static final OsamRepository osamRepository =
      OsamRepositoryImpl(_osamSdk, settings);
}
