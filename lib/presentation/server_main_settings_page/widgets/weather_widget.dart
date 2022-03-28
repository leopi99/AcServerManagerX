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
    return Container(
      child: Column(
        children: [
          InfoLabel(
            label: "weather_type".tr(),
            child: DropDownButton(
              items: List.generate(
                WeatherTypeEnum.values.length,
                (index) => DropDownButtonItem(
                  onTap: () {
                    onChanged(
                        weather.copyWith(type: WeatherTypeEnum.values[index]));
                  },
                  title: Text(
                    WeatherTypeEnum.values[index].name.tr(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
