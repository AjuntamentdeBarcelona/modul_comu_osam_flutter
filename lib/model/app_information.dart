
import 'dart:convert';

class AppInformation {

  String appName;
  String appVersionName;
  String appVersionCode;

  AppInformation([this.appName = "", this.appVersionName = "", this.appVersionCode = ""]) {
  }
}

extension AppInformationExtensions on AppInformation {
  static AppInformation fromJson(String jsonData) {
    var decoded = json.decode(jsonData);
    return AppInformation(decoded["appName"] ?? "", decoded["appVersionName"] ?? "", decoded["appVersionCode"] ?? "");
  }
}