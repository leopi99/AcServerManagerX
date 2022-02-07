import 'package:acservermanager/presentation/skeleton/presentation/skeleton_page.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Widget _homepage;

  @override
  void initState() {
    _homepage = SkeletonPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Assetto Corsa Server Manager X',
      theme: ThemeData.light(),
      home: _homepage,
    );
  }
}
