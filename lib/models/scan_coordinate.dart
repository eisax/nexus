import 'dart:convert';

class ScanCoordinate {
  final double x;
  final double y;
  final int steps;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;

  ScanCoordinate({
    required this.x,
    required this.y,
    required this.steps,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'steps': steps,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ScanCoordinate.fromJson(Map<String, dynamic> json) {
    return ScanCoordinate(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      steps: json['steps'],
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory ScanCoordinate.fromJsonString(String jsonString) {
    return ScanCoordinate.fromJson(jsonDecode(jsonString));
  }
} 