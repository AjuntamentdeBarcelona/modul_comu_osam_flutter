import 'package:common_module_flutter/osam/src/VersionControlResponse.dart';
import 'package:common_module_flutter/internal/rating/model/RateMe.dart';
import 'Message.dart';

class Rating {
  int appId;
  int id;
  String appStoreIdentifier;
  Message? message;
  int minutesUntilInitialPrompt;
  int minLaunchesUntilInitialPrompt;
  String packageName;
  String platform;

  Rating({
    required this.appId,
    required this.id,
    required this.appStoreIdentifier,
    required this.message,
    required this.minutesUntilInitialPrompt,
    required this.minLaunchesUntilInitialPrompt,
    required this.packageName,
    required this.platform,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      appId: json['appId'],
      id: json['id'],
      appStoreIdentifier: json['appStoreIdentifier'],
      message: json['message'] != null
          ? Message.fromJson(json['message'])
          : Message(),
      minutesUntilInitialPrompt: json['minutes'],
      minLaunchesUntilInitialPrompt: json['numAperture'],
      packageName: json['packageName'],
      platform: json['platform'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['id'] = this.id;
    data['appStoreIdentifier'] = this.appStoreIdentifier;
    data['minutes'] = this.minutesUntilInitialPrompt;
    data['numAperture'] = this.minLaunchesUntilInitialPrompt;
    data['packageName'] = this.packageName;
    data['platform'] = this.platform;
    if (this.message != null) {
      data['message'] = this.message?.toJson() ?? Message().toJson();
    }
    return data;
  }

  RateMe toModel(Language language) {
    return RateMe(
      minutesUntilInitialPrompt: minutesUntilInitialPrompt,
      minLaunchesUntilInitialPrompt: minLaunchesUntilInitialPrompt,
      appStoreIdentifier: appStoreIdentifier,
      message: message ?? Message(),
    );
  }
}
