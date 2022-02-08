import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GetIt.instance<AppearanceBloc>().backgroundColor,
      child: const Center(
        child: Text('Homepage'),
      ),
    );
  }
}
