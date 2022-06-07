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
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  Future<void> _runServer(String acPath) async {
    _shellProcess = await Process.start("$acPath/server/acServer.exe", [],
        workingDirectory: '$acPath/server/');
    sub = _shellProcess.outLines.listen((event) {
      _responsesSubject.add([..._responsesSubject.value, event]);
    });
    Logger().log("Server started.", name: "server_run_instance._runServer");
  }

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.atEdge) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceOut,
          );
        }
      },
    );
    _runServer(widget.acPath);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _responsesSubject.close();
    sub.cancel();
    final bool exit = Process.killPid(_shellProcess.pid);
    if (exit) {
      Logger().log("Server killer successfully",
          name: "server_run_instance.dispose");
    } else {
      Logger().log("The server has killed itself",
          name: "server_run_instance.dispose");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStringList();
  }

  Widget _buildStringList() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .7,
      child: StreamBuilder<List<String>>(
        stream: _responsesSubject.stream,
        initialData: const [],
        builder: (context, snapshot) {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _scrollController,
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
