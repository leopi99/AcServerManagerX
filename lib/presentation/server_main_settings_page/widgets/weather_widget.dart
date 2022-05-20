import 'package:acservermanager/models/enums/weather_type_enum.dart';
import 'package:acservermanager/models/weather.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  final Function(Weather) onChanged;

  const WeatherWidget({
    Key? key,
    required this.weather,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoLabel(
          label: "weather_type".tr(),
          child: DropDownButton(
            title: Row(
              children: [
                _buildWeatherIcon(weather.type),
                Text(weather.type.name.tr()),
              ],
            ),
            items: List.generate(
              WeatherTypeEnum.values.length,
              (index) => MenuFlyoutItem(
                onPressed: () {
                  onChanged(
                      weather.copyWith(type: WeatherTypeEnum.values[index]));
                },
                text: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildWeatherIcon(WeatherTypeEnum.values[index]),
                    Text(
                      WeatherTypeEnum.values[index].name.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon([WeatherTypeEnum? type]) {
    type ??= weather.type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(type.icon),
    );
  }
}
