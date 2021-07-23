import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'dto/Rating.dart';
import 'dto/RatingResponse.dart';
import 'dto/Version.dart';
import 'dto/VersionResponse.dart';

class Remote {
  final Dio dio = Dio();

  static String _ENDPOINT = "https://osam-modul-comu.dtibcn.cat";
  static String _VERSION = "api/version";
  static String _RATING = "api/rating";

  Remote(String token) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["Authorization"] = "Basic $token";
      return handler.next(options);
    }));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
  }

  Future<Rating> rating(String appId, String platform) async {
    final response = await dio.get("$_ENDPOINT/$_RATING/$appId/$platform");

    return RatingResponse.fromJson(response.data).data;
  }

  Future<Version> versionControl(String appId, String platform, int version) async {
    final response = await dio.get("$_ENDPOINT/$_VERSION/$appId/$platform/$version");

    return VersionResponse.fromJson(response.data).data;
  }
}
