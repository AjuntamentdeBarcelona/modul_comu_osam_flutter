
import 'dart:convert';

class DeviceInformation {

  String platformName;
  String platformVersion;
  String platformModel;

  DeviceInformation([this.platformName = "", this.platformVersion = "", this.platformModel = ""]) {
  }

}

extension DeviceInformationExtensions on DeviceInformation {
  static DeviceInformation fromJson(String jsonData) {
    var decoded = json.decode(jsonData);
    return DeviceInformation(decoded["platformName"] ?? "", decoded["platformVersion"] ?? "", decoded["platformModel"] ?? "");
  }
}