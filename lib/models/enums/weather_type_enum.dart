import 'package:fluent_ui/fluent_ui.dart';
import 'package:weather_icons/weather_icons.dart';

enum WeatherTypeEnum {
  clear,
  heavyClouds,
  heavyFog,
  lightClouds,
  lightFog,
  midClear,
  midClouds,
}

extension WeatherTypeEnumExtension on WeatherTypeEnum {
  IconData get icon {
    late IconData icon;
    switch (this) {
      case WeatherTypeEnum.clear:
        icon = WeatherIcons.day_sunny;
        break;
      case WeatherTypeEnum.heavyClouds:
        icon = WeatherIcons.cloudy;
        break;
      case WeatherTypeEnum.heavyFog:
        icon = WeatherIcons.fog;
        break;
      case WeatherTypeEnum.lightClouds:
        icon = WeatherIcons.cloudy;
        break;
      case WeatherTypeEnum.lightFog:
        icon = WeatherIcons.fog;
        break;
      case WeatherTypeEnum.midClear:
        icon = WeatherIcons.day_sunny;
        break;
      case WeatherTypeEnum.midClouds:
        icon = WeatherIcons.night_partly_cloudy;
        break;
    }
    return icon;
  }
}
