class Car {
  final String name;
  final String brand;
  final String description;
  final List<String> tags;
  final String carClass;
  final String filePath;

  const Car({
    required this.brand,
    required this.description,
    required this.name,
    required this.tags,
    required this.carClass,
    required this.filePath,
  });

  factory Car.fromJson(Map<String, dynamic> json, String filePath) {
    return Car(
      brand: json['brand'],
      carClass: json['class'],
      description: json['description'],
      filePath: filePath,
      name: json['name'],
      tags: json['tags'],
    );
  }
}
