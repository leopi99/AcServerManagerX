import 'package:acservermanager/models/enums/weather_type_enum.dart';
import 'package:acservermanager/models/server.dart';
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

  static Weather fromServerData(List<String> data) {
    return Weather(
      ambientVariation:
          int.parse(Server.getStringFromData(data, "VARIATION_AMBIENT")),
      baseAmbientTemp:
          int.parse(Server.getStringFromData(data, "BASE_TEMPERATURE_AMBIENT")),
      baseRoadTemp:
          int.parse(Server.getStringFromData(data, "BASE_TEMPERATURE_ROAD")),
      baseWindDirection:
          int.parse(Server.getStringFromData(data, "WIND_BASE_DIRECTION")),
      baseWindMaxSpeed:
          int.parse(Server.getStringFromData(data, "WIND_BASE_SPEED_MAX")),
      baseWindMinSpeed:
          int.parse(Server.getStringFromData(data, "WIND_BASE_SPEED_MIN")),
      realisticRoadTemp: 7,
      // roadVariation: Server.getStringFromData(data, "VARIATION_AMBIENT"), TODO:
      // timeOfDay: Server.getStringFromData(data, "VARIATION_AMBIENT"), TODO:
      timeOfDayMultiplier:
          int.parse(Server.getStringFromData(data, "TIME_OF_DAY_MULT")),
      type: _getGraphicEnum(Server.getStringFromData(data, "GRAPHICS")),
      windDirectionVar:
          int.parse(Server.getStringFromData(data, "WIND_VARIATION_DIRECTION")),
    );
  }

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

  List<String> toStringList() => [
        'GRAPHICS=${_getGraphicText()}',
        'BASE_TEMPERATURE_AMBIENT=$baseAmbientTemp',
        'BASE_TEMPERATURE_ROAD=$baseRoadTemp',
        'VARIATION_AMBIENT=$ambientVariation',
        'VARIATION_ROAD=$roadVariation',
        'WIND_BASE_SPEED_MIN=$baseWindMinSpeed',
        'WIND_BASE_SPEED_MAX=$baseWindMaxSpeed',
        'WIND_BASE_DIRECTION=$baseWindDirection',
        'WIND_VARIATION_DIRECTION=$windDirectionVar',
      ];

  ///Returns a [String] rappresentation of the [WeatherTypeEnum] for the graphics line in the config file.
  String _getGraphicText() {
    switch (type) {
      case WeatherTypeEnum.clear:
        return "3_clear";
      case WeatherTypeEnum.heavyClouds:
        return "7_heavy_clouds";
      case WeatherTypeEnum.heavyFog:
        return "1_heavy_fog";
      case WeatherTypeEnum.lightClouds:
        return "5_light_clouds";
      case WeatherTypeEnum.lightFog:
        return "2_light_fog";
      case WeatherTypeEnum.midClear:
        return "4_mid_clear";
      case WeatherTypeEnum.midClouds:
        return "6_mid_clouds";
    }
  }

  static WeatherTypeEnum _getGraphicEnum(String value) {
    switch (value) {
      case "3_clear":
        return WeatherTypeEnum.clear;
      case "7_heavy_clouds":
        return WeatherTypeEnum.heavyClouds;
      case "1_heavy_fog":
        return WeatherTypeEnum.heavyFog;
      case "5_light_clouds":
        return WeatherTypeEnum.lightClouds;
      case "2_light_fog":
        return WeatherTypeEnum.lightFog;
      case "4_mid_clear":
        return WeatherTypeEnum.midClear;
      case "6_mid_clouds":
        return WeatherTypeEnum.midClouds;
      default:
        return WeatherTypeEnum.clear;
    }
  }
}
