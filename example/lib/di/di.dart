import 'package:common_module_flutter/osam.dart';
import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/data/osam/osam_repository_impl.dart';
import 'package:common_module_flutter_example/data/settings/app_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static late SharedPreferences _prefs;
  static late OSAM _osamSdk;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _prefs = await SharedPreferences.getInstance();
    _osamSdk = await OSAM.init("https://dev-osam-modul-comu.dtibcn.cat",
        _onCrashlyticsException, _onAnalyticsEvent);
  }

  static final Settings settings = AppPreferences(_prefs);
  static final OsamRepository osamRepository =
      OsamRepositoryImpl(_osamSdk, settings);

  static _onCrashlyticsException(String className, String stackTrace) async {
    await FirebaseCrashlytics.instance.recordError(
        className, StackTrace.fromString(stackTrace),
        reason: stackTrace);
  }

  static _onAnalyticsEvent(String name, Map<String, String> parameters) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameters);
  }
}
