import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/car.dart';
import 'package:flutter/foundation.dart';

class CarHelper {
  static const _kCarsPath = "/content/cars/";
  static const _kCarJson = "/ui/ui_car.json";

  static Future<List<Car>> loadCars(
      {required String acPath, required Function(String) onError}) async {
    final carsDir = Directory(acPath + _kCarsPath);
    List<Car> cars = [];

    try {
      await Future.forEach(carsDir.listSync(), (element) async {
        element as FileSystemEntity;
        final file = File(element.path + _kCarJson);
        //Adds the car only if the file exists
        if (file.existsSync()) {
          cars.add(
            await Car.fromJson(
                jsonDecode(String.fromCharCodes(await file.readAsBytes())
                    .replaceAll(RegExp(r"\s+"), ' ')),
                element.path),
          );
        }
      });
    } catch (e, stacktrace) {
      debugPrint('Error: $e\nStackTrace:\n$stacktrace');
      onError(e.toString());
      return [];
    }
    return cars;
  }
}
