import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/widgets/search_bar.dart';
import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/car_selection_page/presentation/widgets/car_widget.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CarSelectionPage extends StatefulWidget {
  const CarSelectionPage({Key? key}) : super(key: key);

  @override
  State<CarSelectionPage> createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  SessionBloc? _sessionBloc;

  BehaviorSubject<List<Car>> availableCars = BehaviorSubject.seeded([]);

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _sessionBloc ??= BlocProvider.of<SessionBloc>(context);
      _sessionBloc!.add(SessionLoadCarsEvent());
      availableCars.add(_sessionBloc!.loadedCars);
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
    availableCars.close();
    _sessionBloc!.add(SessionUnloadCarsEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      bloc: _sessionBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SessionCarsLoadedState) {
          return Stack(
            children: [
              StreamBuilder<Server>(
                stream:
                    SelectedServerInherited.of(context).selectedServerStream,
                builder: (context, _) {
                  return StreamBuilder<List<Car>>(
                    stream: availableCars,
                    initialData: const [],
                    builder: (context, carSnapshot) {
                      if (carSnapshot.data!.isEmpty) {
                        return Center(child: Text("no_car_found".tr()));
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width ~/ 128,
                        ),
                        padding: const EdgeInsets.all(16)
                            .copyWith(bottom: 64, top: 64),
                        itemBuilder: (context, index) =>
                            CarWidget(car: carSnapshot.data![index]),
                        itemCount: carSnapshot.data!.length,
                      );
                    },
                  );
                },
              ),
              SearchBar<Car>(
                searchList: _sessionBloc!.loadedCars,
                hint: "search_car".tr(),
                onSearch: (cars) => availableCars.add(cars),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
