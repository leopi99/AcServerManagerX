import 'dart:io';

import 'package:acservermanager/models/car/skin.dart';
import 'package:acservermanager/models/car_specs.dart';
import 'package:acservermanager/models/searcheable_element.dart';
import 'package:equatable/equatable.dart';

class Car extends SearcheableElement implements Equatable {
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
  }) : super(name);

  static Future<Car> fromJson(Map<String, dynamic> json, String path) async {
    List<CarSkin> skins = [];
    int index = 0;
    await Future.forEach<FileSystemEntity>(
        Directory(path + "/skins").listSync(), (e) async {
      skins.add(await CarSkin.fromDir(Directory(e.path), index));
      index++;
    });
    return Car(
      brand: json['brand'],
      carClass: json.containsKey('class') ? json['class'] : '',
      description: json['description'],
      path: path,
      name: json['name'],
      tags: json.containsKey('tags')
          ? (json['tags'] as List).map((e) => "$e").toList()
          : [],
      specs:
          json.containsKey('specs') ? CarSpecs.fromJson(json['specs']) : null,
      skins: skins,
    );
  }

  String get logoPath => path + "/logo.png";

  String get defaultPreview => skins.first.previewPath;

  @override
  List<Object?> get props => [
        path,
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

  @override
  String get searchTerm => name;

  @override
  bool? get stringify => true;
}
