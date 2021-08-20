import 'Version.dart';

class VersionResponse {
  Version data;
  int statusCode;

  VersionResponse({required this.data, required this.statusCode});

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      data: Version.fromJson(json['data']),
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.toJson();
    return data;
  }
}
