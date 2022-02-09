import 'package:equatable/equatable.dart';

abstract class SessionBase extends Equatable {
  final bool enabled;
  final int time;

  const SessionBase({
    this.enabled = true,
    this.time = 10,
  });
}
