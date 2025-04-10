import 'package:flutter/foundation.dart';

class Logger {
  void info(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }

  void error(String message) {
    if (kDebugMode) {
      print('ERROR: $message');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      print('WARNING: $message');
    }
  }
}
