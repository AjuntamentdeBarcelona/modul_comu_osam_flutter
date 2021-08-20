import 'Rating.dart';

class RatingResponse {
  Rating data;
  int statusCode;

  RatingResponse({required this.data, required this.statusCode});

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      data: Rating.fromJson(json['data']),
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
