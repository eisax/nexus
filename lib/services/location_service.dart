import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nexus/data/models/points.dart';
import 'package:nexus/data/json/findPath.dart';

class LocationService extends GetxController {
  static LocationService get to => Get.find();
  
  final Rx<Point?> currentPoint = Rx<Point?>(null);
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxList<Point> allPoints = <Point>[].obs;
  final RxBool isTracking = false.obs;
  
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _updateTimer;
  
  @override
  void onInit() {
    super.onInit();
    _loadPoints();
  }
  
  Future<void> _loadPoints() async {
    try {
      final points = await loadCampusLocations(pointsIds: []);
      allPoints.value = points;
    } catch (e) {
      print('Error loading points: $e');
    }
  }
  
  Future<void> startTracking() async {
    if (isTracking.value) return;
    
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }
      
      // Start position updates
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Update every 5 meters
        ),
      ).listen((Position position) {
        currentPosition.value = position;
        _updateCurrentPoint(position);
      });
      
      isTracking.value = true;
      
      // Also update periodically to ensure we have the latest point
      _updateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (currentPosition.value != null) {
          _updateCurrentPoint(currentPosition.value!);
        }
      });
      
    } catch (e) {
      print('Error starting location tracking: $e');
      isTracking.value = false;
    }
  }
  
  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _updateTimer?.cancel();
    isTracking.value = false;
  }
  
  void _updateCurrentPoint(Position position) {
    if (allPoints.isEmpty) return;
    
    // Find the closest point to current position
    Point? closestPoint;
    double? minDistance;
    
    for (var point in allPoints) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        point.latitude,
        point.longitude,
      );
      
      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
      }
    }
    
    // Only update if we found a point and it's different from current
    if (closestPoint != null && 
        (currentPoint.value == null || 
         currentPoint.value!.point != closestPoint.point)) {
      currentPoint.value = closestPoint;
    }
  }
  
  double? getDistanceToPoint(Point targetPoint) {
    if (currentPosition.value == null) return null;
    
    return Geolocator.distanceBetween(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      targetPoint.latitude,
      targetPoint.longitude,
    );
  }
  
  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
} 