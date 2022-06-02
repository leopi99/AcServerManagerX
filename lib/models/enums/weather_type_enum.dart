import 'package:fluent_ui/fluent_ui.dart';
import 'package:weather_icons/weather_icons.dart';

enum WeatherTypeEnum {
  clear(WeatherIcons.day_sunny),
  heavyClouds(WeatherIcons.cloudy),
  heavyFog(WeatherIcons.fog),
  lightClouds(WeatherIcons.cloudy),
  lightFog(WeatherIcons.fog),
  midClear(WeatherIcons.day_sunny),
  midClouds(WeatherIcons.night_partly_cloudy);

  const WeatherTypeEnum(this.icon);
  final IconData icon;
}
