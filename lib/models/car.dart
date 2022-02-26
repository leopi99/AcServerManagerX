import 'package:acservermanager/models/car_specs.dart';

class Car {
  final String name;
  final String brand;
  final String description;
  final List<String> tags;
  final String carClass;
  final String filePath;
  final CarSpecs? specs;

  const Car({
    required this.brand,
    required this.description,
    required this.name,
    required this.tags,
    required this.carClass,
    required this.filePath,
    this.specs,
  });

  factory Car.fromJson(Map<String, dynamic> json, String filePath) {
    return Car(
      brand: json['brand'],
      carClass: json['class'],
      description: json['description'],
      filePath: filePath,
      name: json['name'],
      tags: json['tags'],
      specs:
          json.containsKey('specs') ? CarSpecs.fromJson(json['specs']) : null,
    );
  }

  String get logoPath => filePath + "/logo.png";

}
