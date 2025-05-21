// 1. Define the Point class with fromJson
class Point {
  final int point;
  final double latitude;
  final double longitude;
  final String name;

  Point({
    required this.point,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  // ✅ Factory constructor to create Point from JSON
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      point: json['point'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'Point $point: $name at ($latitude, $longitude)';
  }
}

