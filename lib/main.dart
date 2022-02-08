import 'package:acservermanager/common/loading_bloc/loading_bloc_bloc.dart';
import 'package:acservermanager/common/singletons.dart';
import 'package:acservermanager/presentation/select_app_theme/presentation/select_app_theme_page.dart';
import 'package:acservermanager/presentation/skeleton/presentation/skeleton_page.dart';
import 'package:acservermanager/presentation/splash_screen/presentation/splash_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await Singletons.initSingletons();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Widget _homepage;
  late final LoadingBlocBloc _bloc;

  @override
  void initState() {
    _homepage = SkeletonPage();
    _bloc = LoadingBlocBloc();
    _bloc.add(LoadingBlocLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Assetto Corsa Server Manager X',
      theme: ThemeData.light(),
      home: BlocListener<LoadingBlocBloc, LoadingBlocState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is LoadingBlocSetAcPathState) {
            final TextEditingController _controller = TextEditingController();
            debugPrint('Showing the set ac path dialog');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                title: const Text('Select the installation path of AC'),
                content: TextBox(
                  controller: _controller,
                  onSubmitted: (value) {
                    if (value.isEmpty) return;
                    _bloc.add(LoadingBlocAcPathSet(value));
                    _controller.dispose();
                  },
                  suffix: Tooltip(
                    message: 'Open the directory picker',
                    child: IconButton(
                      icon: const Icon(FluentIcons.folder),
                      onPressed: () async {
                        String? dir = await FilePicker.platform
                            .getDirectoryPath(
                                dialogTitle:
                                    'Select the installation path of AC');
                        if (dir != null) {
                          dir = dir.replaceAll('\\', "/");
                          _controller.text = dir;
                          debugPrint('Selected directory: $dir');
                          _bloc.add(LoadingBlocAcPathSet(_controller.text));
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
                actions: [
                  FilledButton(
                    child: const Text('Set path'),
                    onPressed: () {
                      if (_controller.text.isEmpty) return;
                      _bloc.add(LoadingBlocAcPathSet(_controller.text));
                      _controller.dispose();
                    },
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<LoadingBlocBloc, LoadingBlocState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingBlocLoadingState) {
              debugPrint('Loading state');
              return const SplashScreen();
            }
            if (state is LoadingBlocInitial ||
                state is LoadingBlocSetAcPathState) {
              debugPrint('Showing ${state.runtimeType}');
              return Container(
                color: Colors.white,
              );
            }
            if (state is LoadingBlocSetAppAppearanceState) {
              return SelectAppThemePage(
                bloc: _bloc,
              );
            }
            return _homepage;
          },
        ),
      ),
    );
  }
}
