import 'package:acservermanager/models/session/session_base.dart';

class Qualifying extends SessionBase {
  final bool canJoin;
  final int qualifyLimitPerc;

  const Qualifying({
    this.canJoin = true,
    this.qualifyLimitPerc = 120,
    bool enabled = true,
    int time = 10,
  }) : super(enabled: enabled, time: time);

  Qualifying copyWith({
    bool? enabled,
    int? time,
    bool? canJoin,
    int? qualifyLimitPerc,
  }) {
    return Qualifying(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
      canJoin: canJoin ?? this.canJoin,
      qualifyLimitPerc: qualifyLimitPerc ?? this.qualifyLimitPerc,
    );
  }
}
