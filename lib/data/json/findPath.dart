import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nexus/data/models/points.dart';
import 'package:geolocator/geolocator.dart';

// Custom PriorityQueue implementation for Dijkstra's algorithm
class PriorityQueue<T> {
  final List<T> _items = [];
  final int Function(T, T) _compare;

  PriorityQueue(this._compare);

  void add(T item) {
    _items.add(item);
    _items.sort(_compare);
  }

  T removeFirst() {
    return _items.removeAt(0);
  }

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
}

Future<List<int>> findPath(Map<int, List<int>> graph, int start, int goal) async {
  if (!graph.containsKey(start) || !graph.containsKey(goal)) {
    throw ArgumentError('Start or goal node not found in the graph.');
  }

  // Load points data to get coordinates
  final String contents = await rootBundle.loadString('assets/json/points.json');
  final List<dynamic> jsonData = jsonDecode(contents);
  final Map<int, Point> pointsMap = {};
  for (var data in jsonData) {
    final point = Point.fromJson(data);
    pointsMap[point.point] = point;
  }

  // Priority queue for Dijkstra's algorithm
  final queue = PriorityQueue<MapEntry<int, double>>(
    (a, b) => a.value.compareTo(b.value)
  );
  queue.add(MapEntry(start, 0.0));

  // Maps to store distances and previous nodes
  final distances = <int, double>{};
  final previous = <int, int>{};
  final visited = <int>{};

  // Initialize distances
  for (var node in graph.keys) {
    distances[node] = double.infinity;
  }
  distances[start] = 0.0;

  while (queue.isNotEmpty) {
    final current = queue.removeFirst().key;
    
    if (current == goal) {
      // Reconstruct path
      final path = <int>[];
      var node = goal;
      while (node != start) {
        path.insert(0, node);
        node = previous[node]!;
      }
      path.insert(0, start);
      return path;
    }

    if (visited.contains(current)) continue;
    visited.add(current);

    for (var neighbor in graph[current]!) {
      if (visited.contains(neighbor)) continue;

      // Calculate actual distance between points
      final currentPoint = pointsMap[current]!;
      final neighborPoint = pointsMap[neighbor]!;
      final distance = Geolocator.distanceBetween(
        currentPoint.latitude,
        currentPoint.longitude,
        neighborPoint.latitude,
        neighborPoint.longitude,
      );

      final newDistance = distances[current]! + distance;
      if (newDistance < distances[neighbor]!) {
        distances[neighbor] = newDistance;
        previous[neighbor] = current;
        queue.add(MapEntry(neighbor, newDistance));
      }
    }
  }

  return [];
}

Future<List<Point>> fetchRoute({required List<int> pointsIds}) async {
  try {
    final String contents = await rootBundle.loadString(
      'assets/json/points.json',
    );
    final List<dynamic> jsonData = jsonDecode(contents);

    List<Point> allPoints =
        jsonData.map((data) => Point.fromJson(data)).toList();

    // Create a map for quick lookup
    final Map<int, Point> pointMap = {
      for (var p in allPoints) p.point: p,
    };

    // Preserve the order of pointsIds
    final List<Point> orderedPoints = pointsIds
        .map((id) => pointMap[id])
        .whereType<Point>()
        .toList();

    return orderedPoints;
  } catch (e) {
    print('Error loading or parsing points.json: $e');
    return [];
  }
}


Future<List<Point>> loadCampusLocations({required List<int> pointsIds}) async {
  try {
    final String contents = await rootBundle.loadString(
      'assets/json/points.json',
    );
    final List<dynamic> jsonData = jsonDecode(contents);

    List<Point> allPoints =
        jsonData.map((data) => Point.fromJson(data)).toList();

    // List of allowed point values

    return allPoints;
  } catch (e) {
    print('Error loading or parsing points.json: $e');
    return [];
  }
}
