import 'package:common_module_flutter/di/DI.dart';

abstract class AnalyticsApi {
  Future<void> logEvent(
      {required String name, required Map<String, dynamic> parameters});
}

class FirebaseAnalyticsApi implements AnalyticsApi {
  @override
  Future<void> logEvent({required String name, required Map<String, dynamic> parameters}) {
    return DI.firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }
}

class DummyAnalyticsApi implements AnalyticsApi {
  @override
  // ignore: missing_return
  Future<void> logEvent({required String name, required Map<String, dynamic> parameters}) async {
    final eventlog = "logEvent: name $name parameters: $parameters";
    print(eventlog);
  }
}
