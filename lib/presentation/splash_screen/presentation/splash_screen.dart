import 'package:fluent_ui/fluent_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          ProgressRing(activeColor: Colors.white),
          SizedBox(height: 32),
          Text('Loading...'),
        ],
      ),
    );
  }
}
