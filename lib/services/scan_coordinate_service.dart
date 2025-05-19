import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexus/models/scan_coordinate.dart';

class ScanCoordinateService {
  static const String _storageKey = 'scan_coordinates';
  final SharedPreferences _prefs;

  ScanCoordinateService(this._prefs);

  Future<void> saveCoordinates(List<ScanCoordinate> coordinates) async {
    final List<String> jsonList = coordinates.map((c) => c.toJsonString()).toList();
    await _prefs.setStringList(_storageKey, jsonList);
  }

  List<ScanCoordinate> getCoordinates() {
    final List<String>? jsonList = _prefs.getStringList(_storageKey);
    if (jsonList == null) return [];
    
    return jsonList
        .map((json) => ScanCoordinate.fromJsonString(json))
        .toList();
  }

  Future<void> addCoordinate(ScanCoordinate coordinate) async {
    final coordinates = getCoordinates();
    coordinates.add(coordinate);
    await saveCoordinates(coordinates);
  }

  Future<void> clearCoordinates() async {
    await _prefs.remove(_storageKey);
  }

  // Get coordinates as a list of points for path drawing
  List<Map<String, double>> getPathPoints() {
    return getCoordinates().map((coord) => {
      'x': coord.x,
      'y': coord.y,
    }).toList();
  }
} 