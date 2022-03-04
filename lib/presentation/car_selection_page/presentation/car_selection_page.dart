import 'package:acservermanager/presentation/car_selection_page/presentation/widgets/car_widget.dart';
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _sessionBloc ??= BlocProvider.of<SessionBloc>(context);
      _sessionBloc!.add(SessionLoadCarsEvent());
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sessionBloc ??= BlocProvider.of<SessionBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    debugPrint('Disposing cars');
    _sessionBloc!.add(SessionUnloadCarsEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      bloc: _sessionBloc,
      listener: (context, state) {
        if (state is SessionCarsLoadedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is SessionCarsLoadedState) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 128,
            ),
            padding: const EdgeInsets.all(16).copyWith(bottom: 64),
            itemBuilder: (context, index) =>
                CarWidget(car: _sessionBloc!.loadedCars[index]),
            itemCount: _sessionBloc!.loadedCars.length,
          );
        }
        return Container();
      },
    );
  }
}
