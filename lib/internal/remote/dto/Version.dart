import 'Message.dart';

class Version {
  int appId;
  Message cancel;
  ComparisonMode comparisonMode;
  int id;
  Message message;
  Message ok;
  String packageName;
  String platform;
  Message title;
  String url;
  int versionCode;
  String versionName;

  Version({
    required this.appId,
    required this.cancel,
    required this.comparisonMode,
    required this.id,
    required this.message,
    required this.ok,
    required this.packageName,
    required this.platform,
    required this.title,
    required this.url,
    required this.versionCode,
    required this.versionName,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      appId: json['appId'],
      cancel: Message.fromJson(json['cancel']),
      comparisonMode:
          ComparisonModeExtensions.fromString(json['comparisonMode']),
      id: json['id'],
      message: Message.fromJson(json['message']),
      ok: Message.fromJson(json['ok']),
      packageName: json['packageName'],
      platform: json['platform'],
      title: Message.fromJson(json['title']),
      url: json['url'],
      versionCode: json['versionCode'],
      versionName: json['versionName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['comparisonMode'] = this.comparisonMode.asString();
    data['id'] = this.id;
    data['packageName'] = this.packageName;
    data['platform'] = this.platform;
    data['url'] = this.url;
    data['versionCode'] = this.versionCode;
    data['versionName'] = this.versionName;
    data['cancel'] = this.cancel.toJson();
    data['message'] = this.message.toJson();
    data['ok'] = this.ok.toJson();
    data['title'] = this.title.toJson();
    return data;
  }
}

enum ComparisonMode { FORCE, LAZY, INFO, NONE }

extension ComparisonModeExtensions on ComparisonMode {
  static ComparisonMode fromString(String comparisonModeString) {
    ComparisonMode comparisonMode;
    switch (comparisonModeString.toUpperCase()) {
      case "FORCE":
        comparisonMode = ComparisonMode.FORCE;
        break;
      case "LAZY":
        comparisonMode = ComparisonMode.LAZY;
        break;
      case "INFO":
        comparisonMode = ComparisonMode.INFO;
        break;
      case "NONE":
      default:
        comparisonMode = ComparisonMode.NONE;
    }
    return comparisonMode;
  }

  String asString() {
    String value;
    switch (this) {
      case ComparisonMode.FORCE:
        value = "FORCE";
        break;
      case ComparisonMode.LAZY:
        value = "LAZY";
        break;
      case ComparisonMode.INFO:
        value = "INFO";
        break;
      case ComparisonMode.NONE:
      default:
        value = "NONE";
        break;
    }
    return value;
  }

  bool isForce() {
    return asString() == "FORCE";
  }

  bool isLazy() {
    return asString() == "LAZY";
  }

  bool isInfo() {
    return asString() == "INFO";
  }

  bool isNone() {
    return asString() == "NONE";
  }

  bool mustOpenStore() {
    return isLazy() || isForce();
  }
}
