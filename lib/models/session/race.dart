import 'package:acservermanager/models/enums/join_type_enum.dart';
import 'package:equatable/equatable.dart';

class Race extends Equatable {
  final bool enabled;
  final int laps;
  final int raceMinutes;
  final bool extraRaceMinutes;
  final int raceOverTime;
  final int raceWaitTime;
  final int reversedGrid;
  final List<int> mandatoryPit;
  final JoinTypeEnum joinType;

  const Race({
    this.enabled = true,
    this.laps = 10,
    this.raceMinutes = 0,
    this.extraRaceMinutes = false,
    this.raceOverTime = 60,
    this.raceWaitTime = 60,
    this.reversedGrid = 0,
    this.mandatoryPit = const [0, 0],
    this.joinType = JoinTypeEnum.open,
  });

  Race copyWith({
    bool? enabled,
    int? laps,
    int? raceMinutes,
    bool? extraRaceMinutes,
    int? raceOverTime,
    int? raceWaitTime,
    int? reversedGrid,
    List<int>? mandatoryPit,
    JoinTypeEnum? joinType,
  }) =>
      Race(
        enabled: enabled ?? this.enabled,
        laps: laps ?? this.laps,
        raceMinutes: raceMinutes ?? this.raceMinutes,
        extraRaceMinutes: extraRaceMinutes ?? this.extraRaceMinutes,
        raceOverTime: raceOverTime ?? this.raceOverTime,
        raceWaitTime: raceWaitTime ?? this.raceWaitTime,
        reversedGrid: reversedGrid ?? this.reversedGrid,
        mandatoryPit: mandatoryPit ?? this.mandatoryPit,
        joinType: joinType ?? this.joinType,
      );

  @override
  List<Object?> get props => [
        enabled,
        laps,
        raceMinutes,
        extraRaceMinutes,
        raceOverTime,
        raceWaitTime,
        reversedGrid,
        mandatoryPit,
        joinType,
      ];
}
