import 'dart:async';

import 'package:flutter/services.dart';

import 'model/app_information.dart';
import 'model/device_information.dart';
import 'model/language.dart';
import 'model/rating_control_response.dart';
import 'model/version_control_response.dart';

export 'model/language.dart';
export 'model/rating_control_response.dart';
export 'model/version_control_response.dart';

typedef OnCrashlyticsException = Function(String className, String stackTrace);
typedef OnAnalyticsEvent = Function(
    String name, Map<String, String> parameters);

class OSAM {
  static const MethodChannel _methodChannel =
      MethodChannel('common_module_flutter_method_channel');
  static const EventChannel _analyticsEventChannel =
      EventChannel('common_module_flutter_analytics_event_channel');
  static const EventChannel _crashlyticsEventChannel =
      EventChannel('common_module_flutter_crashlytics_event_channel');

  OSAM._();

  static Future<OSAM> init(
      String backendEndpoint,
      OnCrashlyticsException onCrashlyticsException,
      OnAnalyticsEvent onAnalyticsEvent) async {
    await _methodChannel
        .invokeMethod('init', {'backendEndpoint': backendEndpoint});
    _analyticsEventChannel.receiveBroadcastStream().listen((event) {
      String name = event["name"];
      Map<String, String> parameters = Map.from(event["parameters"]);
      onAnalyticsEvent(name, parameters);
    });
    _crashlyticsEventChannel.receiveBroadcastStream().listen((event) {
      String className = event["className"];
      String stackTrace = event["stackTrace"];
      onCrashlyticsException(className, stackTrace);
    });
    return OSAM._();
  }

  Future<VersionControlResponse> versionControl({
    required Language language,
  }) async {
    final String? response = await _methodChannel.invokeMethod(
        'versionControl', {'language': language.toLanguageCode()});
    return VersionControlResponseExtensions.fromString(response ?? "");
  }

  Future<RatingControlResponse> rating({
    required Language language,
  }) async {
    final String? response = await _methodChannel
        .invokeMethod('rating', {'language': language.toLanguageCode()});
    return RatingControlResponseExtensions.fromString(response ?? "");
  }

  Future<DeviceInformation> deviceInformation() async {
    final String? response = await _methodChannel.invokeMethod('deviceInformation');
    return DeviceInformationExtensions.fromJson(response ?? "");
  }

  Future<AppInformation> appInformation() async {
    final String? response = await _methodChannel.invokeMethod('appInformation');
    return AppInformationExtensions.fromJson(response ?? "");
  }
}
