import 'package:flutter/foundation.dart';
import 'app_exception_message.dart';
import 'failures.dart';

class CalculationException implements Exception {
  final String message;
  CalculationException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

Failure handleException(dynamic e, StackTrace stackTrace) {
  if (kDebugMode) {
    debugPrint('=' * 30);
    debugPrint('error: $e');
    debugPrint('stackTrace: $stackTrace');
    debugPrint('=' * 30);
  }

  if (e is CalculationException) {
    return CalculationFailure(e.message);
  } else if (e is CacheException) {
    return CacheFailure(e.message);
  } else if (e is FormatException) {
    return CalculationFailure(AppExceptionMessage.formatError);
  } else if (e is UnsupportedError) {
    return CalculationFailure(e.message ?? AppExceptionMessage.divisionByZero);
  } else {
    return CalculationFailure(AppExceptionMessage.unknown);
  }
}
