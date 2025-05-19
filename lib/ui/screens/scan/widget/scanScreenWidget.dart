import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nexus/app/routes.dart';
import 'package:nexus/models/scan_coordinate.dart';
import 'package:nexus/services/scan_coordinate_service.dart';
import 'package:nexus/ui/screens/scan/widget/frameAnimationWidget.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanScreenWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const ScanScreenWidget({super.key, required this.onCheckTip});

  @override
  State<ScanScreenWidget> createState() => _ScanScreenWidgetState();
}

class _ScanScreenWidgetState extends State<ScanScreenWidget> {
  double _x = 0.0;
  double _y = 0.0;
  late StreamSubscription<GyroscopeEvent> _gyroSubscription;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  late ScanCoordinateService _coordinateService;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  // Coordinate tracking
  List<ScanCoordinate> scannedCoordinates = [];
  int currentStepCount = 0;
  int totalSteps = 0;
  int progress = 0;
  bool isScanning = false;
  DateTime? lastScanTime;
  bool _showCoordinatesList = false;
  
  // Add new camera-related properties
  bool _isMapReady = false;
  CameraPosition? _lastCameraPosition;

  // Add new step counting properties
  bool _isPedometerAvailable = false;
  String _pedometerStatus = 'Initializing...';
  int _lastStepCount = 0;
  DateTime? _lastStepTime;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeSensors();
    _initializePedometer();
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _coordinateService = ScanCoordinateService(prefs);
    scannedCoordinates = _coordinateService.getCoordinates();
    _updateProgress();
    // Don't update markers here, wait for map to be ready
  }

  void _initializeSensors() {
    // Gyroscope for movement
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        double sensitivity = 5.0;
        _x += event.y * sensitivity;
        _y += event.x * sensitivity;
        _x = _x.clamp(-150.0, 150.0);
        _y = _y.clamp(-300.0, 300.0);
      });
    });

    // Pedometer for step counting
    _stepCountSubscription = Pedometer.stepCountStream.listen((StepCount event) {
      setState(() {
        currentStepCount = event.steps;
        if (isScanning) {
          totalSteps += 1;
          _updateProgress();
        }
      });
    });

    _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen((PedestrianStatus event) {
      // Handle pedestrian status if needed
    });
  }

  Future<void> _initializePedometer() async {
    try {
      // First try to get the current step count
      final initialStepCount = await Pedometer.stepCountStream.first;
      _lastStepCount = initialStepCount.steps;
      _lastStepTime = DateTime.now();
      
      setState(() {
        _isPedometerAvailable = true;
        _pedometerStatus = 'Step counting active';
      });

      // Initialize step count stream
      _stepCountSubscription?.cancel();
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          if (!mounted) return;
          
          setState(() {
            final now = DateTime.now();
            final difference = event.steps - _lastStepCount;
            
            if (difference > 0) {
              currentStepCount = event.steps;
              if (isScanning) {
                totalSteps += difference;
                _updateProgress();
              }
              _lastStepCount = event.steps;
              _lastStepTime = now;
            }
          });
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _pedometerStatus = 'Error: $error';
            _isPedometerAvailable = false;
          });
        },
      );

      // Initialize pedestrian status stream
      _pedestrianStatusSubscription?.cancel();
      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus event) {
          if (!mounted) return;
          setState(() {
            _pedometerStatus = event.status.toString();
          });
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _pedometerStatus = 'Error: $error';
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isPedometerAvailable = false;
        _pedometerStatus = 'Step counting not available: $e';
      });
      
      // Fallback to manual step counting if pedometer is not available
      _initializeManualStepCounting();
    }
  }

  void _initializeManualStepCounting() {
    // Implement a simple manual step counter using accelerometer
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!mounted) return;
      
      // Simple step detection based on acceleration magnitude
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > 15.0) { // Threshold for step detection
        setState(() {
          if (isScanning) {
            totalSteps++;
            _updateProgress();
          }
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });
    _updateMapMarkers();
  }

  void _updateMapMarkers() {
    if (!_isMapReady || scannedCoordinates.isEmpty) return;

    final markers = <Marker>{};
    final points = <LatLng>[];

    for (var i = 0; i < scannedCoordinates.length; i++) {
      final coord = scannedCoordinates[i];
      if (coord.latitude != null && coord.longitude != null) {
        final position = LatLng(coord.latitude!, coord.longitude!);
        points.add(position);
        
        markers.add(
          Marker(
            markerId: MarkerId('point_$i'),
            position: position,
            infoWindow: InfoWindow(
              title: 'Point ${i + 1}',
              snippet: 'Steps: ${coord.steps}',
            ),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      if (points.length > 1) {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('path'),
            points: points,
            color: Colors.blue,
            width: 3,
          ),
        };
      }
    });

    if (_mapController != null && points.isNotEmpty) {
      final bounds = _getBoundsForPoints(points);
      // Calculate center point
      final centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
      final centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
      
      _lastCameraPosition = CameraPosition(
        target: LatLng(centerLat, centerLng),
        zoom: 15,
      );
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0),
      );
    }
  }

  LatLngBounds _getBoundsForPoints(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (var point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _updateProgress() {
    if (scannedCoordinates.length > 0) {
      int baseProgress = (scannedCoordinates.length - 1) * 20;
      int stepProgress = (totalSteps / 100 * 20).round();
      setState(() {
        progress = min(baseProgress + stepProgress, 100);
      });
    }
  }

  Future<void> _scanCoordinate() async {
    if (_calculateProximity(Get.width / 2 + _y) > 0.7) {
      try {
        final position = await _getCurrentLocation();
        final coordinate = ScanCoordinate(
          x: _x,
          y: _y,
          steps: currentStepCount,
          timestamp: DateTime.now(),
          latitude: position.latitude,
          longitude: position.longitude,
        );
        
        await _coordinateService.addCoordinate(coordinate);
        
        setState(() {
          scannedCoordinates.add(coordinate);
          isScanning = true;
          lastScanTime = DateTime.now();
          _updateProgress();
        });
      } catch (e) {
        Get.snackbar(
          'Error',
          'Could not get location: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  double _calculateProximity(double panelY) {
    final screenHeight = MediaQuery.of(context).size.height;
    final center = screenHeight / 2;
    final distance = (panelY - center).abs();
    return 1.0 - (distance / center).clamp(0.0, 1.0);
  }

  Future<void> _exportCoordinates() async {
    try {
      final coordinates = scannedCoordinates.map((coord) => {
        'point': scannedCoordinates.indexOf(coord) + 1,
        'latitude': coord.latitude,
        'longitude': coord.longitude,
        'steps': coord.steps,
        'timestamp': coord.timestamp.toIso8601String(),
      }).toList();

      final jsonString = jsonEncode(coordinates);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/coordinates.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Scanned Coordinates',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not export coordinates: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _gyroSubscription.cancel();
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Widget _buildCoordinatesList() {
    return Container(
      width: Get.width * 0.8,
      height: Get.height * 0.7,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scanned Coordinates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: _exportCoordinates,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _showCoordinatesList = false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white30),
          Container(
            height: 200,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                initialCameraPosition: _lastCameraPosition ?? CameraPosition(
                  target: scannedCoordinates.isNotEmpty && 
                         scannedCoordinates.first.latitude != null &&
                         scannedCoordinates.first.longitude != null
                      ? LatLng(
                          scannedCoordinates.first.latitude!,
                          scannedCoordinates.first.longitude!,
                        )
                      : const LatLng(0, 0),
                  zoom: 15,
                ),
                onMapCreated: _onMapCreated,
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onCameraMove: (position) {
                  _lastCameraPosition = position;
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scannedCoordinates.length,
              itemBuilder: (context, index) {
                final coord = scannedCoordinates[index];
                return ListTile(
                  title: Text(
                    'Point ${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Lat: ${coord.latitude?.toStringAsFixed(6) ?? "N/A"}\n'
                    'Long: ${coord.longitude?.toStringAsFixed(6) ?? "N/A"}\n'
                    'Steps: ${coord.steps}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    '${coord.timestamp.hour}:${coord.timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          Positioned(
            child: Stack(
              children: [
                SafeArea(
                  child: Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/close_simple.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromRGBO(255, 255, 255, 0.545),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: widget.onCheckTip,
                                    child: Container(
                                      color: const Color.fromRGBO(0, 0, 0, 0.55),
                                      child: FrameAnimation(
                                        width: 75,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: Get.height / 2.5,
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Image.asset(
                          "assets/images/shoot_icon.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _scanCoordinate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 0.75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _calculateProximity(Get.width / 2 + _y) > 0.7 
                                ? "Tap to scan coordinate" 
                                : "Aim the dot",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _scanCoordinate,
                            child: Container(
                              height: 50,
                              width: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/pan_icon_recover.png",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$progress/100",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: Color(0xffffffff),
                            ),
                          ),
                          if (scannedCoordinates.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              "Coordinates: ${scannedCoordinates.length}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "Steps: $totalSteps",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.list, color: Colors.white),
                              onPressed: () => setState(() => _showCoordinatesList = true),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Get.width / 2 + _x,
            top: Get.width / 2 + _y,
            child: Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ProximityFrameAnimation(
                width: 120,
                height: 120,
                proximity: _calculateProximity(Get.width / 2 + _y),
              ),
            ),
          ),
          if (_showCoordinatesList)
            Positioned(
              top: Get.height * 0.3,
              child: _buildCoordinatesList(),
            ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _pedometerStatus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (!_isPedometerAvailable)
                    const Text(
                      'Using manual step counting',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.orange),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ProximityFrameAnimation extends StatefulWidget {
  final double width;
  final double height;
  final double proximity;

  const ProximityFrameAnimation({
    super.key,
    required this.width,
    required this.height,
    required this.proximity,
  });

  @override
  _ProximityFrameAnimationState createState() =>
      _ProximityFrameAnimationState();
}

class _ProximityFrameAnimationState extends State<ProximityFrameAnimation> {
  final int startFrame = 0;
  final int endFrame =41;
  final Map<int, AssetImage> _frameImages = {};
  int currentFrame = 0;

  Timer? _timer;
  bool isReversing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = startFrame; i <= endFrame; i++) {
      final asset = AssetImage('assets/images/proximity/image$i.png');
      _frameImages[i] = asset;
      precacheImage(asset, context);
    }
  }

  void _startAnimation({required bool forward}) {
    _timer?.cancel();

    final int totalFrames = endFrame - startFrame + 1;
    const duration = Duration(seconds: 5);
    final frameDuration = duration ~/ totalFrames;

    _timer = Timer.periodic(frameDuration, (timer) {
      setState(() {
        if (forward) {
          if (currentFrame < endFrame) {
            currentFrame++;
          } else {
            timer.cancel();
          }
        } else {
          if (currentFrame > startFrame) {
            currentFrame--;
          } else {
            timer.cancel();
          }
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant ProximityFrameAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proximity > 0.7 && isReversing) {
      isReversing = false;
      _startAnimation(forward: true);
    } else if (widget.proximity < 0.4 && !isReversing) {
      isReversing = true;
      _startAnimation(forward: false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _frameImages[currentFrame];

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: image != null
            ? Image(image: image, gaplessPlayback: true, fit: BoxFit.fill)
            : const SizedBox(),
      ),
    );
  }
}

