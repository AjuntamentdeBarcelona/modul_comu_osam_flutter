import 'dart:convert';

/// Information about the device
class DeviceInformation {
  /// Name of the platform
  String platformName;

  /// Version of the platform
  String platformVersion;

  /// Model of the platform
  String platformModel;

  DeviceInformation([
    this.platformName = '',
    this.platformVersion = '',
    this.platformModel = '',
  ]);
}

extension DeviceInformationExtensions on DeviceInformation {
  static DeviceInformation fromJson(String jsonData) {
    final decoded = json.decode(jsonData);
    return DeviceInformation(
      decoded['platformName'] ?? '',
      decoded['platformVersion'] ?? '',
      decoded['platformModel'] ?? '',
    );
  }
}
