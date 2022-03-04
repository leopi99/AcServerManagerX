class SkinDetails {
  final String? name;
  final String driverName;
  final String country;
  final String team;
  final String number;
  final int priority;

  SkinDetails({
    required this.name,
    required this.driverName,
    required this.country,
    required this.team,
    required this.number,
    required this.priority,
  });

  factory SkinDetails.fromJson(Map<String, dynamic> json) {
    return SkinDetails(
      name: json['skinname'],
      driverName: json['drivername'] ?? '',
      country: json['country'] ?? '',
      team: json['team'] ?? '',
      number: "${json['number'] ?? 0}",
      priority: json['priority'] ?? 0,
    );
  }

  ///Returns the name of the skin with the "_" replaced with a space
  String? get cuteName => name?.replaceAll('_', ' ');
}
