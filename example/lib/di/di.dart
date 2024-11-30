import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/data/osam/osam_repository_impl.dart';
import 'package:common_module_flutter_example/data/settings/app_preferences.dart';
import 'package:common_module_flutter_example/model/tuple.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static late SharedPreferences _prefs;
  static late OSAM _osamSdk;
  static Map<String, Tuple<int, HttpMetric>?> performanceCurrentMetrics = {};

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

  static _onPerformanceEvent(
      String uniqueId, String event, Map<String, String> params) async {
    var debugParamsLogs = [];
    params.forEach((key, value) {
      debugParamsLogs.add("$key: $value");
    });
    debugPrint(
        "PerformanceMetric _onPerformanceEvent uniqueId: $uniqueId, event: $event, params(${debugParamsLogs.length}): ${debugParamsLogs.join(', ')}");
    int currentTime = getCurrentTime();
    HttpMetric? metric = performanceCurrentMetrics[uniqueId]?.item2;
    switch (event) {
      case "start":
        String url = params["url"] ?? "";
        HttpMethod httpMethod = HttpMethod.Get;
        for (HttpMethod element in HttpMethod.values) {
          if (element.name.toLowerCase() ==
              (params["httpMethod"] ?? "").toLowerCase()) {
            httpMethod = element;
            break;
          }
        }
        metric = FirebasePerformance.instance.newHttpMetric(url, httpMethod);
        performanceCurrentMetrics[uniqueId] =
            Tuple(item1: currentTime, item2: metric);
        debugPrint(
            "PerformanceMetric case event: $event, uniqueId: $uniqueId, url: $url, httpMethod: $httpMethod");
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
          debugPrint("PerformanceMetric case event: $event, bytes: $bytes");
          metric?.requestPayloadSize = bytes;
        }
        break;
      case "markRequestComplete":
        debugPrint("PerformanceMetric case event: $event");
        break;
      case "markResponseStart":
        debugPrint("PerformanceMetric case event: $event");
        break;
      case "setResponseContentType":
        String? contentType = params["contentType"];
        if (contentType != null) {
          debugPrint(
              "PerformanceMetric case event: $event, contentType: $contentType");
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
          debugPrint(
              "PerformanceMetric case event: $event, responseCode: $responseCode");
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
          debugPrint("PerformanceMetric case event: $event, bytes: $bytes");
          metric?.responsePayloadSize = bytes;
        }
        break;
      case "putAttribute":
        String? attribute = params["attribute"];
        String value = params["value"] ?? "";
        if (attribute != null) {
          debugPrint(
              "PerformanceMetric case event: $event, attribute: $attribute, value: $value");
          metric?.putAttribute(attribute, value);
        }
        break;
      case "stop":
        debugPrint("PerformanceMetric case event: $event");
        metric?.stop();
        //performanceCurrentMetrics.remove(uniqueId);
        break;
    }
    try {
      var keys = performanceCurrentMetrics.keys;
      for (int i = keys.length - 1; i >= 0; i--) {
        var key = keys.toList()[i];
        var value = performanceCurrentMetrics[key];
        if (value == null || value.item1 < currentTime - 600 * 1000) {
          debugPrint("PerformanceMetric deleting old uniqueId: $key");
          performanceCurrentMetrics.remove(key);
        }
      }
    } catch (e) {
      debugPrint("PerformanceMetric deleting old uniqueId error: $e");
    }
  }

  static int getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
