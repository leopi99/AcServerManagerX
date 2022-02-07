import 'package:acservermanager/models/session/session_base.dart';

class Practice extends SessionBase {
  final bool canJoin;

  const Practice({
    this.canJoin = true,
    bool enabled = true,
    int time = 10,
  }) : super(enabled: enabled, time: time);

  Practice copyWith({
    bool? enabled,
    int? time,
    bool? canJoin,
  }) {
    return Practice(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
      canJoin: canJoin ?? this.canJoin,
    );
  }
}
