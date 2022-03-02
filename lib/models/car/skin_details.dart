class SkinDetails {
  final String name;
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
      name: json['name'],
      driverName: json['driverName'],
      country: json['country'],
      team: json['team'],
      number: json['number'],
      priority: json['priority'],
    );
  }
}
