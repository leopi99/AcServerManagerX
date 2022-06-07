import 'dart:async';
import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class Logger {
  static final Logger _singleton = Logger._internal();
  static const String _kLogFilePath = '/server_manager_x.log';

  late final IOSink _logSink;

  final Completer _completer = Completer();

  ///Completes the future when the logger is initialized
  Future<void> get initialized => _completer.future;

  factory Logger() {
    return _singleton;
  }

  Logger._internal() {
    _completer.complete(
      GetIt.I<SharedManager>().getString(SharedKey.acPath).then((acPath) {
        final File log = File("$acPath/$_kLogFilePath");
        if (!log.existsSync()) {
          log.createSync();
        }
        _logSink = log.openWrite(mode: FileMode.write);
        _logSink.write("*****************************\n");
        _logSink.write("** ServerManagerX v0.7.1+2 **\n");
        _logSink.write("*****************************\n");
      }),
    );
  }

  void log(String message, {required String name, bool writeLog = true}) {
    if (kDebugMode) {
      print("$name: $message");
    }
    if (writeLog) {
      _logSink.writeln("${DateTime.now()}: <$name> $message");
    }
  }

  ///Closes the log file, must be done only when the app is being closed
  void closeLogFile() {
    _logSink.close();
  }

  ///Clears the log file
  Future<void> clearLogfile() async {
    GetIt.I<SharedManager>().getString(SharedKey.acPath).then((acPath) {
      final File log = File("$acPath/$_kLogFilePath");
      log.writeAsBytesSync([]);
    });
  }
}
