import 'dart:async';
import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:process_run/utils/process_result_extension.dart';
import 'package:rxdart/rxdart.dart';

class ServerRunInstance {
  static Widget run(String acPath) {
    return _ServerRunInstance(acPath: acPath);
  }
}

class _ServerRunInstance extends StatefulWidget {
  final String acPath;
  const _ServerRunInstance({
    Key? key,
    required this.acPath,
  }) : super(key: key);

  @override
  State<_ServerRunInstance> createState() => _ServerRunInstanceState();
}

class _ServerRunInstanceState extends State<_ServerRunInstance> {
  final BehaviorSubject<List<String>> _responsesSubject =
      BehaviorSubject.seeded([]);
  late StreamSubscription<String> sub;
  late Process _shellProcess;

  Future<void> _runServer(String acPath) async {
    _shellProcess = await Process.start("$acPath/server/acServer.exe", []);
    sub = _shellProcess.outLines.listen((event) {
      _responsesSubject.add([..._responsesSubject.value, event]);
    });
  }

  @override
  void initState() {
    _runServer(widget.acPath);
    super.initState();
  }

  @override
  void dispose() {
    _responsesSubject.close();
    sub.cancel();
    final bool exit = Process.killPid(_shellProcess.pid);
    if (exit) {
      Logger().log("Server killer successfully");
    } else {
      Logger().log("The server has killed itself");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStringList();
  }

  Widget _buildStringList() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .7,
      child: StreamBuilder<List<String>>(
        stream: _responsesSubject.stream,
        initialData: const [],
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Text(snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
