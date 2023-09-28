import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  final int _maxCharactersPerLine = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      print(options.data);
      print("--> ${options.method} ${options.path}");
      print("--> ${options.headers['Authorization']}");
      print("--> ${options.queryParameters}");
      print("Content type: ${options.contentType}");
      print("<-- END HTTP");
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      print(
          "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > _maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / _maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * _maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP");
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print("<-- Error -->");
      print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      print(err.error);
      print(err.message);
    }
    return super.onError(err, handler);
  }
}
