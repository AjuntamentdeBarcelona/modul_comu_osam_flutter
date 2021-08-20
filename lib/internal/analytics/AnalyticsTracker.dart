import 'AnalyticsApis.dart';

class AnalyticsTracker {
  final AnalyticsApi _analytics;

  AnalyticsTracker(this._analytics);

  static const _EVENT_NAME = "osam_commons";
  static const _ITEM_ID_KEY = "item_id";
  static const _EVENT_ID_KEY = "event_id";
  static const _ITEM_ID_VALUE = "osam_commons";

  static Map<String, dynamic> _commonParams = {
    _ITEM_ID_KEY: _ITEM_ID_VALUE,
  };

  Future<void> trackVersionControlShown() {
    Map<String, dynamic> parameters = _getParams(eventIdValue: "version_control_popup_showed");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Future<void> trackVersionControlAccepted() {
    Map<String, dynamic> parameters = _getParams(eventIdValue: "version_control_popup_accepted");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Future<void> trackVersionControlCancelled() {
    Map<String, dynamic> parameters =
        _getParams(eventIdValue: "version_control_popup_cancelled");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Future<void> trackRatingShown() {
    Map<String, dynamic> parameters = _getParams(eventIdValue: "rating_popup_showed");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Future<void> trackRatingAccepted() {
    Map<String, dynamic> parameters = _getParams(eventIdValue: "rating_popup_accepted");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Future<void> trackRatingCancelled() {
    Map<String, dynamic> parameters = _getParams(eventIdValue: "rating_popup_cancelled");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Future<void> trackRatingLater() {
    Map<String, dynamic> parameters = _getParams(eventIdValue: "rating_popup_later");
    return _analytics.logEvent(name: _EVENT_NAME, parameters: parameters);
  }

  Map<String, dynamic> _getParams({required String eventIdValue}) {
    final Map<String, dynamic> parameters = {};
    parameters.addAll(_commonParams);
    parameters[_EVENT_ID_KEY] = eventIdValue;
    return parameters;
  }
}
