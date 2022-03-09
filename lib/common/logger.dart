import 'package:flutter/foundation.dart';

class Logger {
  static final Logger _singleton = Logger._internal();

  factory Logger() {
    return _singleton;
  }

  Logger._internal();

  void log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
