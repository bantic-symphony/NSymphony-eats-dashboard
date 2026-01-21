import 'package:flutter/foundation.dart';

/// Simple logger utility for debugging
class AppLogger {
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void error(String message, {String tag = 'ERROR', Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[$tag] $message');
      if (error != null) {
        print('[$tag] Error: $error');
      }
      if (stackTrace != null) {
        print('[$tag] StackTrace: $stackTrace');
      }
    }
  }

  static void success(String message, {String tag = 'SUCCESS'}) {
    if (kDebugMode) {
      print('[$tag] ✅ $message');
    }
  }
}
