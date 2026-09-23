import 'package:dio/dio.dart';

String getSyncErrorMessage(DioException e) {
  if (e.response?.statusCode == 401) return 'انتهت صلاحية الجلسة، سجّل دخول من جديد';
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return 'لا يوجد اتصال بالإنترنت';
  }
  if (e.type == DioExceptionType.connectionError) return 'لا يوجد اتصال بالإنترنت';
  return 'خطأ غير متوقع، حاول لاحقاً';
}

bool isSessionExpired(DioException e) => e.response?.statusCode == 401;
