import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/car/skin_details.dart';
import 'package:flutter/foundation.dart';

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

  static Future<CarSkin> fromDir(Directory dir) async {
    SkinDetails? details;
    if (File(dir.path + _kSkinDetails).existsSync()) {
      try {
        details = SkinDetails.fromJson(
          json.decode(
            (await File(dir.path + _kSkinDetails).readAsString())
                .replaceAll(RegExp(r"\s+"), ' '),
          ),
        );
      } catch (e, stacktrace) {
        debugPrint("For car ${dir.path}");
        debugPrint('Error retrieving skin details: $e\nStacktrace: $stacktrace');
      }
    }
    return CarSkin(
      path: dir.path,
      details: details,
    );
  }

  String get previewPath => '$path$_kCarSkin';

  String get liveryPath => '$path$_kCarLivery';
}
