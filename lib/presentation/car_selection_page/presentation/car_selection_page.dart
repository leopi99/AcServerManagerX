import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarSelectionPage extends StatefulWidget {
  const CarSelectionPage({Key? key}) : super(key: key);

  @override
  State<CarSelectionPage> createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  SessionBloc? _sessionBloc;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _sessionBloc = BlocProvider.of<SessionBloc>(context);
      _sessionBloc!.add(SessionLoadCarsEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('Disposing cars');
    _sessionBloc!.add(SessionUnloadCarsEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
