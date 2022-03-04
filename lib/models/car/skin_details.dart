import 'package:equatable/equatable.dart';

class SkinDetails extends Equatable {
  final String name;
  final String driverName;
  final String country;
  final String team;
  final String number;
  final int priority;

  const SkinDetails({
    required this.name,
    required this.driverName,
    required this.country,
    required this.team,
    required this.number,
    required this.priority,
  });

  factory SkinDetails.fromJson(Map<String, dynamic> json, {required String name}) {
    return SkinDetails(
      name: (json['skinname'] as String).isEmpty
          ? name
          : json['skinname'],
      driverName: json['drivername'] ?? '',
      country: json['country'] ?? '',
      team: json['team'] ?? '',
      number: "${json['number'] ?? 0}",
      priority: json['priority'] ?? 0,
    );
  }

  ///Returns the name of the skin with the "_" replaced with a space
  String get cuteName => name.replaceAll('_', ' ');

  @override
  List<Object?> get props =>
      [name, driverName, country, team, number, priority];
}
