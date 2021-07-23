import 'Version.dart';

class VersionResponse {
  Version data;
  int statusCode;

  VersionResponse({this.data, this.statusCode});

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      data: json['data'] != null ? Version.fromJson(json['data']) : null,
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
