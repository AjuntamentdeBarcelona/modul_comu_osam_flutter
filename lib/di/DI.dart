import 'package:common_module_flutter/internal/analytics/AnalyticsApis.dart';
import 'package:common_module_flutter/internal/analytics/AnalyticsTracker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class DI {
  static final AnalyticsTracker tracker =
      AnalyticsTracker(FirebaseAnalyticsApi());

  static final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
}
