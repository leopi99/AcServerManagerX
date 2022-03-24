import 'dart:async';

import 'package:acservermanager/common/logger.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:process_run/shell.dart';
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
  late StreamSubscription<List<int>> sub;

  late Completer _completer;

  final Shell shell = Shell();

  Future<void> _runServer(String acPath) async {
    _completer = Completer();
    _completer.complete(
      shell.run(
        "$acPath/server/acServer.exe",
        onProcess: (process) {
          sub = process.stdout.listen(
            (event) {
              _responsesSubject.add(
                  [..._responsesSubject.value, String.fromCharCodes(event)]);
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _runServer(widget.acPath);
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    _responsesSubject.close();
    if (!_completer.isCompleted) {
      _completer.completeError(1);
    }
    final bool exit = shell.kill();
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
