import 'package:flutter/material.dart';

class Weather {
  final WeatherTypeEnum type;
  final int baseAmbientTemp;
  final int realisticRoadTemp;
  final int baseRoadTemp;
  final int ambientVariation;
  final int roadVariation;
  final int baseWindMinSpeed;
  final int baseWindMaxSpeed;
  final int baseWindDirection;
  final int windDirectionVar;
  final TimeOfDay timeOfDay;
  final int timeOfDayMultiplier;

  const Weather({
    this.type = WeatherTypeEnum.clear,
    this.baseAmbientTemp = 20,
    this.realisticRoadTemp = 8,
    this.baseRoadTemp = 7,
    this.ambientVariation = 2,
    this.roadVariation = 2,
    this.baseWindMinSpeed = 0,
    this.baseWindMaxSpeed = 5,
    this.baseWindDirection = 45,
    this.windDirectionVar = 5,
    this.timeOfDay = const TimeOfDay(hour: 13, minute: 0),
    this.timeOfDayMultiplier = 1,
  });

  Weather copyWith({
    WeatherTypeEnum? type,
    int? baseAmbientTemp,
    int? realisticRoadTemp,
    int? baseRoadTemp,
    int? ambientVariation,
    int? roadVariation,
    int? baseWindMinSpeed,
    int? baseWindMaxSpeed,
    int? baseWindDirection,
    int? windDirectionVar,
    TimeOfDay? timeOfDay,
    int? timeOfDayMultiplier,
  }) {
    return Weather(
      type: type ?? this.type,
      baseAmbientTemp: baseAmbientTemp ?? this.baseAmbientTemp,
      realisticRoadTemp: realisticRoadTemp ?? this.realisticRoadTemp,
      baseRoadTemp: baseRoadTemp ?? this.baseRoadTemp,
      ambientVariation: ambientVariation ?? this.ambientVariation,
      roadVariation: roadVariation ?? this.roadVariation,
      baseWindMinSpeed: baseWindMinSpeed ?? this.baseWindMinSpeed,
      baseWindMaxSpeed: baseWindMaxSpeed ?? this.baseWindMaxSpeed,
      baseWindDirection: baseWindDirection ?? this.baseWindDirection,
      windDirectionVar: windDirectionVar ?? this.windDirectionVar,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      timeOfDayMultiplier: timeOfDayMultiplier ?? this.timeOfDayMultiplier,
    );
  }
}

enum WeatherTypeEnum {
  clear,
  heavyClouds,
  heavyFog,
  lightClouds,
  lightFog,
  midClear,
  midClouds,
}
