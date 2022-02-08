import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GetIt.instance<AppearanceBloc>().backgroundColor,
      child: ListView(
        children: [
          Text('Server base settings'),
          TextBox(
            placeholder: 'Server name',
          ),
        ],
      ),
    );
  }
}
