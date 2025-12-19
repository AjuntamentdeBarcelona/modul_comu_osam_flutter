import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// A custom interceptor to handle Firebase Performance Monitoring for Dio requests.
class PerformanceInterceptor extends Interceptor {
  final HttpMetric metric;

  PerformanceInterceptor(this.metric);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    metric.start();
    // Set request payload size if available
    if (options.data != null) {
      if (options.data is String) {
        metric.requestPayloadSize = (options.data as String).length;
      } else if (options.data is List<int>) {
        metric.requestPayloadSize = (options.data as List<int>).length;
      }
    }

    // Add request headers as attributes
    options.headers.forEach((key, value) {
      metric.putAttribute('requestHeaderKey:$key', 'requestHeaderValue:$value');
    });

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Set response attributes
    metric.httpResponseCode = response.statusCode;
    final contentType = response.headers.value('content-type');
    if (contentType != null) {
      metric.responseContentType = contentType;
    }

    final contentLength = response.headers.value('content-length');
    if (contentLength != null) {
      metric.responsePayloadSize = int.tryParse(contentLength);
    }

    // Add response headers as attributes
    response.headers.forEach((key, values) {
      metric.putAttribute(
          'responseHeaderKey:$key', 'responseHeaderValue:${values.join(',')}');
    });

    metric.stop();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Set response attributes if a response was received
    if (err.response != null) {
      metric.httpResponseCode = err.response?.statusCode;
      final contentType = err.response?.headers.value('content-type');
      if (contentType != null) {
        metric.responseContentType = contentType;
      }
      final contentLength = err.response?.headers.value('content-length');
      if (contentLength != null) {
        metric.responsePayloadSize = int.tryParse(contentLength);
      }
    }
    metric.stop();
    handler.next(err);
  }
}

/// Builds a Dio HTTP client with default configurations and interceptors.
///
/// [endpoint]: The base URL for the API.
/// [metric]: An optional [HttpMetric] for performance tracking.
/// [block]: An optional function to apply further custom configuration to the Dio instance.
Dio buildClient(
  String endpoint, {
  HttpMetric? metric,
  void Function(Dio dio)? block,
}) {
  final uri = Uri.parse(endpoint);
  final baseUrl = Uri(scheme: uri.scheme, host: uri.host).toString();

  final options = BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Basic b3NhbTpvc2Ft',
    },
  );

  final dio = Dio(options);

  // Add logging in debug mode
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => debugPrint(o.toString()),
    ));
  }

  // Add performance interceptor if a metric is provided
  if (metric != null) {
    dio.interceptors.add(PerformanceInterceptor(metric));
  }

  // Apply any additional custom configuration
  block?.call(dio);

  return dio;
}

/// Performs a PUT request to the specified endpoint and path.
///
/// [endpoint]: The base URL for the API.
/// [path]: The path for the PUT request.
/// [data]: The data to be sent in the request body.
/// [metric]: An optional [HttpMetric] for performance tracking.
Future<Response> performPutRequest(
  String endpoint,
  String path,
  dynamic data, {
  HttpMetric? metric,
}) async {
  final client = buildClient(endpoint, metric: metric);

  try {
    final response = await client.put(path, data: data);
    return response;
  } finally {
    client.close();
  }
}
