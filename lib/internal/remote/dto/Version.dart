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

  Version(
      {this.appId,
      this.cancel,
      this.comparisonMode,
      this.id,
      this.message,
      this.ok,
      this.packageName,
      this.platform,
      this.title,
      this.url,
      this.versionCode,
      this.versionName});

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      appId: json['appId'],
      cancel: json['cancel'] != null ? Message.fromJson(json['cancel']) : null,
      comparisonMode:
          ComparisonModeExtensions.fromString(json['comparisonMode']),
      id: json['id'],
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
      ok: json['ok'] != null ? Message.fromJson(json['ok']) : null,
      packageName: json['packageName'],
      platform: json['platform'],
      title: json['title'] != null ? Message.fromJson(json['title']) : null,
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
    if (this.cancel != null) {
      data['cancel'] = this.cancel.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    if (this.ok != null) {
      data['ok'] = this.ok.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
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
