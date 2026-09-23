import 'package:dio/dio.dart';

String getSyncErrorMessage(DioException e) {
  if (e.response?.statusCode == 401) return 'Session expired, please sign in again';
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return 'No internet connection';
  }
  if (e.type == DioExceptionType.connectionError) return 'No internet connection';
  return 'Unexpected error, please try again later';
}

bool isSessionExpired(DioException e) => e.response?.statusCode == 401;
