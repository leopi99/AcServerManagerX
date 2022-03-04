import 'dart:io';

import 'package:acservermanager/models/car/skin.dart';
import 'package:acservermanager/models/car_specs.dart';
import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String name;
  final String brand;
  final String description;
  final List<String> tags;
  final String carClass;
  final String path;
  final CarSpecs? specs;
  final List<CarSkin> skins;

  const Car({
    required this.brand,
    required this.description,
    required this.name,
    required this.tags,
    required this.carClass,
    required this.path,
    this.skins = const [],
    this.specs,
  });

  static Future<Car> fromJson(Map<String, dynamic> json, String path) async {
    List<CarSkin> skins = [];
    await Future.forEach<FileSystemEntity>(
        Directory(path + "/skins").listSync(), (e) async {
      skins.add(await CarSkin.fromDir(Directory(e.path)));
    });
    return Car(
      brand: json['brand'],
      carClass: json['class'],
      description: json['description'],
      path: path,
      name: json['name'],
      tags: (json['tags'] as List).map((e) => "$e").toList(),
      specs:
          json.containsKey('specs') ? CarSpecs.fromJson(json['specs']) : null,
      skins: skins,
    );
  }

  String get logoPath => path + "/logo.png";

  String get defaultPreview => skins.first.previewPath;

  @override
  List<Object?> get props => [
        name,
        brand,
        description,
        tags,
        carClass,
        path,
        specs,
      ];

  Car copyWith({
    String? name,
    String? brand,
    String? description,
    List<String>? tags,
    String? carClass,
    String? path,
    CarSpecs? specs,
    List<CarSkin>? skins,
  }) {
    return Car(
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      carClass: carClass ?? this.carClass,
      path: path ?? this.path,
      specs: specs ?? this.specs,
      skins: skins ?? this.skins,
    );
  }
}
