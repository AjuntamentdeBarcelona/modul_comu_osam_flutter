import 'package:common_module_flutter/di/DI.dart';
import 'package:flutter/widgets.dart';

abstract class AnalyticsApi {
  Future<void> logEvent(
      {@required String name, Map<String, dynamic> parameters});
}

class FirebaseAnalyticsApi implements AnalyticsApi {
  @override
  Future<void> logEvent({String name, Map<String, dynamic> parameters}) {
    return DI.firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }
}

class DummyAnalyticsApi implements AnalyticsApi {
  @override
  // ignore: missing_return
  Future<void> logEvent({String name, Map<String, dynamic> parameters}) {
    final eventlog = "logEvent: name $name parameters: $parameters";
    print(eventlog);
  }
}
