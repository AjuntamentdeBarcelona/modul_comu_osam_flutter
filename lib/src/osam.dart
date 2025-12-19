import 'dart:async';

import 'package:flutter/services.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';

/// A callback type that is returned a className and stackTrace whenever an
/// exception
typedef OnCrashlyticsException = Function(String className, String stackTrace);

/// A callback type that is returned a analytics name event and their parameters
typedef OnAnalyticsEvent = Function(
  String name,
  Map<String, String> parameters,
);

/// A callback type that is returned a performance name event and their params
typedef OnPerformanceEvent = Function(
  String uniqueId,
  String event,
  Map<String, String> params,
);

/// A single callback that provides the topic and the action ('subscribe' or
/// 'unsubscribe')
typedef OnMessagingEvent = Function(String topic, String action);

class OSAM {
  static const MethodChannel _methodChannel =
      MethodChannel('common_module_flutter_method_channel');
  static const EventChannel _analyticsEventChannel =
      EventChannel('common_module_flutter_analytics_event_channel');
  static const EventChannel _crashlyticsEventChannel =
      EventChannel('common_module_flutter_crashlytics_event_channel');
  static const EventChannel _performanceEventChannel =
      EventChannel('common_module_flutter_performance_event_channel');
  static const EventChannel _messagingEventChannel =
      EventChannel('common_module_flutter_messaging_event_channel');

  OSAM._();

  static Future<OSAM> init(
    /// The backend endpoint to which the library will make requests.
    ///
    /// Example: `https://dev-osam-modul-comu.dtibcn.cat/`
    String backendEndpoint,

    /// It is called whenever an exception occurs in the library, so it can
    /// be reported to whatever crash reporting service is used.
    /// For example, Firebase Crashlytics.
    OnCrashlyticsException onCrashlyticsException,

    /// It is called when a relevant event occurs in the library
    /// (display one of the pop-ups, press one button, an error occurs,etc).
    ///
    /// Provides an event name and a number of parameters that can be
    /// passed to the analytics service being used.
    /// For example, Firebase Analytics.
    OnAnalyticsEvent onAnalyticsEvent,

    /// It is called every time a network call occurs to the library,
    /// so that it can be reported to the performance reporting service
    /// being used. For example, Firebase Performance.
    OnPerformanceEvent onPerformanceEvent,

    /// It is called when the native library requests to subscribe
    /// or unsubscribe from a specific topic.
    /// For example, Firebase Messaging.
    OnMessagingEvent onMessagingEvent,
  ) async {
    await _methodChannel
        .invokeMethod('init', {'backendEndpoint': backendEndpoint});
    _analyticsEventChannel.receiveBroadcastStream().listen((event) {
      final String name = event['name'];
      final Map<String, String> parameters = Map.from(event['parameters']);
      onAnalyticsEvent(name, parameters);
    });
    _crashlyticsEventChannel.receiveBroadcastStream().listen((event) {
      final String className = event['className'];
      final String stackTrace = event['stackTrace'];
      onCrashlyticsException(className, stackTrace);
    });
    _performanceEventChannel.receiveBroadcastStream().listen((event) {
      final String uniqueId = event['uniqueId'];
      final String e = event['event'];
      final Map<String, String> params = {};
      switch (e) {
        case 'start':
          params['url'] = event['url'];
          params['httpMethod'] = event['httpMethod'];
          break;
        case 'setRequestPayloadSize':
          params['bytes'] = event['bytes'];
          break;
        case 'markRequestComplete':
          break;
        case 'markResponseStart':
          break;
        case 'setResponseContentType':
          params['contentType'] = event['contentType'];
          break;
        case 'setHttpResponseCode':
          params['responseCode'] = event['responseCode'];
          break;
        case 'setResponsePayloadSize':
          params['bytes'] = event['bytes'];
          break;
        case 'putAttribute':
          params['attribute'] = event['attribute'];
          params['value'] = event['value'];
          break;
        case 'stop':
          break;
      }
      onPerformanceEvent(uniqueId, e, params);
    });
    _messagingEventChannel.receiveBroadcastStream().listen((event) {
      if (event is Map) {
        final String? topic = event['topic'];
        final String? action = event['action'];

        if (topic != null && action != null) {
          onMessagingEvent(topic, action);
        }
      }
    });

    return OSAM._();
  }

  /// Download json from backend,
  /// show version control alert with message parsed by [language]
  /// and return status of user action with alert message.
  ///
  /// The alert only appers if the [requirements](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/doc/bussiness_logic.md#control-de-versions)
  /// for it to be displayed are met.
  Future<VersionControlResponse> versionControl({
    required Language language,
  }) async {
    final String? response = await _methodChannel.invokeMethod(
      'versionControl',
      {'language': language.toLanguageCode()},
    );
    return VersionControlResponseExtensions.fromString(response ?? '');
  }

  /// Download json from backend,
  /// show rating alert with message parsed by [language]
  /// and return status of rating popup behavior
  ///
  /// The alert only appers if the [requirements](https://github.com/AjuntamentdeBarcelona/modul_comu_osam_flutter/blob/main/doc/bussiness_logic.md#control-de-valoracions)
  /// for it to be displayed are met.
  Future<RatingControlResponse> rating({
    required Language language,
  }) async {
    final String? response = await _methodChannel
        .invokeMethod('rating', {'language': language.toLanguageCode()});
    return RatingControlResponseExtensions.fromString(response ?? '');
  }

  /// Get information about the device
  Future<DeviceInformation> deviceInformation() async {
    final String? response =
        await _methodChannel.invokeMethod('deviceInformation');
    return DeviceInformationExtensions.fromJson(response ?? '');
  }

  /// Get information about the app
  Future<AppInformation> appInformation() async {
    final String? response =
        await _methodChannel.invokeMethod('appInformation');
    return AppInformationExtensions.fromJson(response ?? '');
  }

  /// Get information about the language
  Future<AppLanguageResponse> changeLanguageEvent({
    required Language language,
  }) async {
    final String? response = await _methodChannel.invokeMethod(
      'changeLanguageEvent',
      {'language': language.toLanguageCode()},
    );
    return AppLanguageResponseExtensions.fromString(response ?? '');
  }

  Future<AppLanguageResponse> firstTimeOrUpdateAppEvent({
    required Language language,
  }) async {
    final String? response = await _methodChannel.invokeMethod(
      'firstTimeOrUpdateAppEvent',
      {'language': language.toLanguageCode()},
    );
    return AppLanguageResponseExtensions.fromString(response ?? '');
  }

  Future<SubscriptionResponse> subscribeToCustomTopic({
    required String topic,
  }) async {
    final String? response = await _methodChannel.invokeMethod(
      'subscribeToCustomTopic',
      {'topic': topic},
    );
    return SubscriptionResponseExtensions.fromString(response ?? '');
  }

  Future<SubscriptionResponse> unsubscribeToCustomTopic({
    required String topic,
  }) async {
    final String? response = await _methodChannel.invokeMethod(
      'unsubscribeToCustomTopic',
      {'topic': topic},
    );
    return SubscriptionResponseExtensions.fromString(response ?? '');
  }

  Future<TokenResponse> getFCMToken() async {
    try {
      // On success, the native side sends the token String directly.
      final String token = await _methodChannel.invokeMethod('getFCMToken');
      return Success(token);
    } on PlatformException catch (e) {
      // On failure, the native side sends a PlatformException.
      return Error(e);
    } catch (e) {
      // Catch any other unexpected errors.
      return Error(Exception('An unexpected error occurred: $e'));
    }
  }
}
