import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:pdos_app/core/utils/sync_error_helper.dart';

DioException _makeException({
  int? statusCode,
  DioExceptionType type = DioExceptionType.unknown,
  String? message,
}) {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    response: statusCode != null
        ? Response(requestOptions: RequestOptions(path: '/test'), statusCode: statusCode)
        : null,
    type: type,
    message: message,
  );
}

void main() {
  group('getSyncErrorMessage', () {
    test('401 statusCode returns session expired message', () {
      final e = _makeException(statusCode: 401, type: DioExceptionType.badResponse);
      expect(getSyncErrorMessage(e), 'انتهت صلاحية الجلسة، سجّل دخول من جديد');
    });

    test('connectionTimeout returns no internet message', () {
      final e = _makeException(type: DioExceptionType.connectionTimeout);
      expect(getSyncErrorMessage(e), 'لا يوجد اتصال بالإنترنت');
    });

    test('receiveTimeout returns no internet message', () {
      final e = _makeException(type: DioExceptionType.receiveTimeout);
      expect(getSyncErrorMessage(e), 'لا يوجد اتصال بالإنترنت');
    });

    test('sendTimeout returns no internet message', () {
      final e = _makeException(type: DioExceptionType.sendTimeout);
      expect(getSyncErrorMessage(e), 'لا يوجد اتصال بالإنترنت');
    });

    test('connectionError returns no internet message', () {
      final e = _makeException(type: DioExceptionType.connectionError);
      expect(getSyncErrorMessage(e), 'لا يوجد اتصال بالإنترنت');
    });

    test('generic error returns fallback message', () {
      final e = _makeException(type: DioExceptionType.unknown, statusCode: 500);
      expect(getSyncErrorMessage(e), 'خطأ غير متوقع، حاول لاحقاً');
    });

    test('cancel type returns fallback message', () {
      final e = _makeException(type: DioExceptionType.cancel);
      expect(getSyncErrorMessage(e), 'خطأ غير متوقع، حاول لاحقاً');
    });

    test('badResponse with non-401 returns fallback message', () {
      final e = _makeException(type: DioExceptionType.badResponse, statusCode: 422);
      expect(getSyncErrorMessage(e), 'خطأ غير متوقع، حاول لاحقاً');
    });
  });

  group('isSessionExpired', () {
    test('returns true for statusCode 401', () {
      final e = _makeException(statusCode: 401);
      expect(isSessionExpired(e), true);
    });

    test('returns false for statusCode 403', () {
      final e = _makeException(statusCode: 403);
      expect(isSessionExpired(e), false);
    });

    test('returns false when no response', () {
      final e = _makeException(type: DioExceptionType.connectionTimeout);
      expect(isSessionExpired(e), false);
    });
  });
}
