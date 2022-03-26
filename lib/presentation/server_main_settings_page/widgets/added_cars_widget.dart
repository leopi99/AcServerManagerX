import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/presentation/car_selection_page/presentation/widgets/car_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart' show Icons;

class AddedCarsWidget extends StatelessWidget {
  final List<Car> cars;
  final Function() onClose;
  const AddedCarsWidget({
    Key? key,
    required this.cars,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      width: MediaQuery.of(context).size.width * .4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GetIt.I<AppearanceBloc>().backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (MediaQuery.of(context).size.width * .4) ~/ 128,
            ),
            padding: const EdgeInsets.all(16).copyWith(bottom: 64, top: 64),
            itemBuilder: (context, index) => CarWidget(car: cars[index]),
            itemCount: cars.length,
          ),
          Tooltip(
            message: "close".tr(),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
