import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class SelectAcPathPage extends StatefulWidget {
  final Function() onDone;
  const SelectAcPathPage({
    Key? key,
    required this.onDone,
  }) : super(key: key);

  @override
  State<SelectAcPathPage> createState() => _SelectAcPathPageState();
}

class _SelectAcPathPageState extends State<SelectAcPathPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    debugPrint('Ac path set');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ContentDialog(
          title: const Text('Select the installation path of AC'),
          content: TextBox(
            controller: _controller,
            onSubmitted: (value) async {
              if (value.isEmpty) return;
              debugPrint('Selected directory: $value');
              await GetIt.I<SharedManager>()
                  .setString(SharedKey.acPath, _controller.text);
              Navigator.pop(context);
              widget.onDone();
            },
            suffix: Tooltip(
              message: 'Open the directory picker',
              child: IconButton(
                icon: const Icon(FluentIcons.folder),
                onPressed: () async {
                  String? dir = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: 'Select the installation path of AC');
                  if (dir != null) {
                    dir = dir.replaceAll('\\', "/");
                    _controller.text = dir;
                    debugPrint('Selected directory: $dir');
                    await GetIt.I<SharedManager>()
                        .setString(SharedKey.acPath, _controller.text);
                    Navigator.pop(context);
                    widget.onDone();
                  }
                },
              ),
            ),
          ),
          actions: [
            FilledButton(
              child: const Text('Set path'),
              onPressed: () async {
                if (_controller.text.isEmpty) return;
                await GetIt.I<SharedManager>()
                    .setString(SharedKey.acPath, _controller.text);
                Navigator.pop(context);
                widget.onDone();
              },
            ),
          ],
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GetIt.instance<AppearanceBloc>().backgroundColor,
    );
  }
}
