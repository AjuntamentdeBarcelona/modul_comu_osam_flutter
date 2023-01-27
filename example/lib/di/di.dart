import 'package:common_module_flutter/osam.dart';
import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/data/osam/osam_repository_impl.dart';
import 'package:common_module_flutter_example/data/settings/app_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DI {
  static late SharedPreferences _prefs;
  static late OSAM _osamSdk;
  static Map<String, HttpMetric> performanceCurrentMetrics = {};

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _prefs = await SharedPreferences.getInstance();
    _osamSdk = await OSAM.init("https://dev-osam-modul-comu.dtibcn.cat",
        _onCrashlyticsException, _onAnalyticsEvent, _onPerformanceEvent);
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

  static _onPerformanceEvent(String uniqueId, String event,
      Map<String, String> params) async {
    HttpMetric? metric = performanceCurrentMetrics[uniqueId];
    switch (event) {
      case "start":
        HttpMethod httpMethod = HttpMethod.Get;
        for (HttpMethod element in HttpMethod.values) {
          if (element.name.toLowerCase() ==
              (params["httpMethod"] ?? "").toLowerCase()) {
            httpMethod = element;
            break;
          }
        }
        metric = FirebasePerformance.instance
            .newHttpMetric(params["url"] ?? "", httpMethod);
        performanceCurrentMetrics[uniqueId] = metric;
        await metric.start();
        break;
      case "setRequestPayloadSize":
        int? bytes;
        try {
          bytes = int.parse(params["bytes"]!);
        } catch (e) {
          bytes = null;
        }
        if (bytes != null) {
          metric?.requestPayloadSize = bytes;
        }
        break;
      case "markRequestComplete":
        break;
      case "markResponseStart":
        break;
      case "setResponseContentType":
        String? contentType = params["contentType"];
        if (contentType != null) {
          metric?.responseContentType = contentType;
        }
        break;
      case "setHttpResponseCode":
        int? responseCode;
        try {
          responseCode = int.parse(params["responseCode"]!);
        } catch (e) {
          responseCode = null;
        }
        if (responseCode != null) {
          metric?.httpResponseCode = responseCode;
        }
        break;
      case "setResponsePayloadSize":
        int? bytes;
        try {
          bytes = int.parse(params["bytes"]!);
        } catch (e) {
          bytes = null;
        }
        if (bytes != null) {
          metric?.responsePayloadSize = bytes;
        }
        break;
      case "putAttribute":
        String? attribute = params["attribute"];
        String value = params["value"] ?? "";
        if (attribute != null) {
          metric?.putAttribute(attribute, value);
        }
        break;
      case "stop":
        metric?.stop();
        performanceCurrentMetrics.remove(uniqueId);
        break;
    }
  }
}
