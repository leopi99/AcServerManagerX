import 'package:acservermanager/models/session/practice.dart';
import 'package:acservermanager/models/session/qualifying.dart';
import 'package:acservermanager/models/session/race.dart';
import 'package:acservermanager/models/weather.dart';

class Session {
  final Practice practice;
  final Qualifying qualifying;
  final Race race;
  final Weather weather;

  Session({
    this.practice = const Practice(),
    this.qualifying = const Qualifying(),
    this.race = const Race(),
    this.weather = const Weather(),
  });
}
