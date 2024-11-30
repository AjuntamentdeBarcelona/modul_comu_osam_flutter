import 'dart:convert';

/// Information about the app
class AppInformation {
  /// Name of the app
  String appName;

  /// Code name of the version
  String appVersionName;

  /// Numeric code of the app
  String appVersionCode;

  AppInformation([
    this.appName = '',
    this.appVersionName = '',
    this.appVersionCode = '',
  ]);
}

extension AppInformationExtensions on AppInformation {
  static AppInformation fromJson(String jsonData) {
    final decoded = json.decode(jsonData);
    return AppInformation(
      decoded['appName'] ?? '',
      decoded['appVersionName'] ?? '',
      decoded['appVersionCode'] ?? '',
    );
  }
}
