import 'dart:async';
import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class Logger {
  static final Logger _singleton = Logger._internal();
  static const String _kLogFilePath = '/server_manager_x.log';

  late final IOSink? _logSink;

  final Completer _completer = Completer();

  ///Completes the future when the logger is initialized
  Future<void> get initialized => _completer.future;

  factory Logger() {
    return _singleton;
  }

  Logger._internal() {
    _completer.complete(setLogFile());
  }

  void log(String message, {required String name, bool writeLog = true}) {
    if (kDebugMode) {
      print("$name: $message");
    }
    if (writeLog && _logSink != null) {
      _logSink!.writeln("${DateTime.now()}: <$name> $message");
    }
  }

  ///Closes the log file, must be done only when the app is being closed
  void closeLogFile() {
    _logSink?.close();
  }

  ///Sets the log file.
  ///
  ///Should be called once and only when the acPath is available,
  /// otherwise won't initialize
  Future<void> setLogFile() async {
    final String? acPath =
        await GetIt.I<SharedManager>().getString(SharedKey.acPath);
    if (acPath == null) {
      return;
    }
    final File log = File("$acPath/$_kLogFilePath");
    if (!log.existsSync()) {
      log.createSync();
    }
    _logSink = log.openWrite(mode: FileMode.write);
    _logSink!.write("*****************************\n");
    _logSink!.write("** ServerManagerX v0.7.2+3 **\n");
    _logSink!.write("*****************************\n");
  }

  ///Clears the log file
  Future<void> clearLogfile() async {
    GetIt.I<SharedManager>().getString(SharedKey.acPath).then((acPath) {
      final File log = File("$acPath/$_kLogFilePath");
      log.writeAsBytesSync([]);
    });
  }
}
