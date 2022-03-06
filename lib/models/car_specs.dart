class CarSpecs {
  final String bhp;
  final String torque;
  final String weight;
  final String topSpeed;
  final String accelleration;
  final String pwRatio;
  final String range;

  const CarSpecs({
    required this.accelleration,
    required this.bhp,
    required this.pwRatio,
    required this.range,
    required this.topSpeed,
    required this.torque,
    required this.weight,
  });

  factory CarSpecs.fromJson(Map<String, dynamic> json) {
    return CarSpecs(
      accelleration: json['accelleration'] ?? "",
      bhp: json['bhp'],
      pwRatio: json['pwratio'],
      range: json.containsKey('range') ? json['range'].toString() : "0",
      topSpeed: json['topspeed'],
      torque: json['torque'],
      weight: json['weight'],
    );
  }
}
