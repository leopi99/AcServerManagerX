import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/car/skin_details.dart';

class CarSkin {
  static const String _kCarSkin = '/preview.jpg';
  static const String _kCarLivery = '/livery.png';
  static const String _kSkinDetails = '/ui_skin.json';
  final String path;
  final SkinDetails? details;

  const CarSkin({
    required this.path,
    required this.details,
  });

  factory CarSkin.fromDir(Directory dir) {
    SkinDetails? details;
    if (File(dir.path + _kSkinDetails).existsSync()) {
      details = SkinDetails.fromJson(
          json.decode(File(dir.path + _kSkinDetails).readAsStringSync()));
    }
    return CarSkin(
      path: dir.path,
      details: details,
    );
  }

  String get previewPath => '$path$_kCarSkin';
  String get liveryPath => '$path$_kCarLivery';
}
