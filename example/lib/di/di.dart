import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/data/osam/osam_repository_impl.dart';
import 'package:common_module_flutter_example/data/settings/app_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static late OSAM _osamSdk;
  static late Settings _prefs;

  static OSAM get osamSdk => _osamSdk;
  static Settings get settings => _prefs;
  static late OsamRepository osamRepository;

  static Future<void> initialize() async {
    debugPrint("DI: Initializing...");
    await Firebase.initializeApp();
    _initializeMessaging();

    final sharedPrefs = await SharedPreferences.getInstance();
    _prefs = AppPreferences(sharedPrefs);

    debugPrint("DI: Forcing settings to TRUE...");
    await _prefs.setShowVersionControlPopup(true);
    await _prefs.setShowRatingPopup(true);

    debugPrint(
        "DI: Setting values - VC: ${_prefs.getShowVersionControlPopup()}, Rating: ${_prefs.getShowRatingPopup()}");

    _osamSdk = await OSAM.init(
        "https://dev-osam-modul-comu.dtibcn.cat",
        _onCrashlyticsException,
        _onAnalyticsEvent,
        _onPerformanceEvent,
        _onMessagingEvent);

    osamRepository = OsamRepositoryImpl(_osamSdk, _prefs);
    debugPrint("DI: Initialization complete.");
  }

  static void _onCrashlyticsException(String className, String stackTrace) {
    debugPrint("CrashlyticsEvent: $className - $stackTrace");
  }

  static void _onAnalyticsEvent(String name, Map<String, String> parameters) {
    debugPrint("AnalyticsEvent: $name - $parameters");
  }

  static void _onPerformanceEvent(
      String uniqueId, String event, Map<String, String> params) {
    debugPrint("PerformanceEvent: $uniqueId - $event - $params");
  }

  static void _onMessagingEvent(String topic, String action) {
    debugPrint("MessagingEvent: $topic - $action");
  }

  static void _initializeMessaging() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        debugPrint("FCM Token: $token");
      }
    } catch (e) {
      debugPrint("Error caching token: $e");
    }
  }
}
