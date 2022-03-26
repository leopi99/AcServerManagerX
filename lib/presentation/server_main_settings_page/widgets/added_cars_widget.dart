import 'package:acservermanager/models/car.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AddedCarsWidget extends StatelessWidget {
  final List<Car> cars;
  const AddedCarsWidget({
    Key? key,
    required this.cars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .9,
      width: MediaQuery.of(context).size.width * .4,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * .1),
    );
  }
}
