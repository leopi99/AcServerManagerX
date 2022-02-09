import 'package:acservermanager/models/session/practice.dart';
import 'package:acservermanager/models/session/qualifying.dart';
import 'package:acservermanager/models/session/race.dart';
import 'package:acservermanager/models/track.dart';
import 'package:acservermanager/models/weather.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final Practice practice;
  final Qualifying qualifying;
  final Race race;
  final Weather weather;
  final Track? selectedTrack;

  const Session({
    this.practice = const Practice(),
    this.qualifying = const Qualifying(),
    this.race = const Race(),
    this.weather = const Weather(),
    this.selectedTrack,
  });

  Session copyWith({
    Practice? practice,
    Qualifying? qualifying,
    Race? race,
    Weather? weather,
    Track? selectedTrack,
  }) =>
      Session(
        practice: practice ?? this.practice,
        qualifying: qualifying ?? this.qualifying,
        race: race ?? this.race,
        weather: weather ?? this.weather,
        selectedTrack: selectedTrack ?? this.selectedTrack,
      );

  @override
  List<Object?> get props => [
        practice,
        qualifying,
        race,
        weather,
        selectedTrack,
      ];
}
