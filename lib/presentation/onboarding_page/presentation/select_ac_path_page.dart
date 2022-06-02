import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:easy_localization/easy_localization.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ContentDialog(
          title: Text('select_ac_path'.tr()),
          content: TextBox(
            controller: _controller,
            onSubmitted: (value) async {
              if (value.isEmpty) return;
              Logger().log('Selected directory: $value');
              Navigator.pop(context);
              await GetIt.I<SharedManager>()
                  .setString(SharedKey.acPath, _controller.text);
              widget.onDone();
            },
            suffix: Tooltip(
              message: 'open_dir_picker'.tr(),
              child: IconButton(
                icon: const Icon(FluentIcons.folder),
                onPressed: () async {
                  String? dir = await FilePicker.platform
                      .getDirectoryPath(dialogTitle: 'select_ac_path'.tr());
                  if (dir != null) {
                    dir = dir.replaceAll('\\', "/");
                    _controller.text = dir;
                    Logger().log('Selected directory: $dir');
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
              child: Text('set_path'.tr()),
              onPressed: () async {
                if (_controller.text.isEmpty) return;
                Navigator.pop(context);
                await GetIt.I<SharedManager>()
                    .setString(SharedKey.acPath, _controller.text);
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
