import 'package:flutter/foundation.dart';

class Logger {
  static final Logger _singleton = Logger._internal();

  factory Logger() {
    return _singleton;
  }

  Logger._internal();

  void log(String message, {String? name}) {
    if (kDebugMode) {
      print("${name ?? 'Log'}: $message");
    }
  }

  static logg(String message, {String? name}) =>
      Logger().log(message, name: name);
}
