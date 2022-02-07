import 'package:acservermanager/models/session/practice.dart';
import 'package:acservermanager/models/session/qualifying.dart';
import 'package:acservermanager/models/session/race.dart';
import 'package:acservermanager/models/weather.dart';

class Session {
  final Practice practice;
  final Qualifying qualifying;
  final Race race;
  final Weather weather;

  const Session({
    this.practice = const Practice(),
    this.qualifying = const Qualifying(),
    this.race = const Race(),
    this.weather = const Weather(),
  });

  Session copyWith({
    Practice? practice,
    Qualifying? qualifying,
    Race? race,
    Weather? weather,
  }) =>
      Session(
        practice: practice ?? this.practice,
        qualifying: qualifying ?? this.qualifying,
        race: race ?? this.race,
        weather: weather ?? this.weather,
      );
}
