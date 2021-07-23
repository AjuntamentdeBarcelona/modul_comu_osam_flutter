import 'Rating.dart';

class RatingResponse {
  Rating data;
  int statusCode;

  RatingResponse({this.data, this.statusCode});

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      data: json['data'] != null ? Rating.fromJson(json['data']) : null,
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
