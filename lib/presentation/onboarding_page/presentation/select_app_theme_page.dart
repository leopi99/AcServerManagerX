import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class SelectAppThemePage extends StatefulWidget {
  final Function() onDone;
  const SelectAppThemePage({
    Key? key,
    required this.onDone,
  }) : super(key: key);

  @override
  State<SelectAppThemePage> createState() => _SelectAppThemePageState();
}

class _SelectAppThemePageState extends State<SelectAppThemePage> {
  late final AppearanceBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.instance<AppearanceBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _bloc.darkMode,
      initialData: true,
      builder: (context, snapshot) {
        return Container(
          color: _bloc.backgroundColor,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _bloc.setDarkMode(value: true);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FluentIcons.user_window,
                            color: Color.fromARGB(255, 49, 49, 49),
                            size: 128,
                          ),
                          Text('dark_mode'.tr()),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _bloc.setDarkMode(value: false);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FluentIcons.user_window,
                            color: Color.fromARGB(255, 223, 223, 223),
                            size: 128,
                          ),
                          Text('light_mode'.tr()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32, bottom: 32),
                  child: FilledButton(
                    child: const Text('Done'),
                    onPressed: () {
                      widget.onDone();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
