import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:nexus/data/json/findPath.dart';
import 'package:nexus/data/json/pointsgraph.dart';
import 'package:nexus/data/models/points.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/screens/components/image/custom_svg_picture.dart';
import 'package:nexus/ui/screens/components/image/my_local_image_widget.dart';
import 'package:nexus/ui/screens/components/textfield/customTextfieldWidget.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';
import 'package:nexus/utils/my_icons.dart';
import 'package:nexus/utils/my_images.dart';
import 'package:nexus/utils/util.dart';
import 'dart:ui';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:nexus/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Navigation data structure
class NavigationStep {
  final String action;
  final double distance;
  final double? expectedHeading;
  final String instruction;
  final Point point;

  NavigationStep({
    required this.action,
    required this.distance,
    this.expectedHeading,
    required this.instruction,
    required this.point,
  });

  factory NavigationStep.fromJson(Map<String, dynamic> json) {
    return NavigationStep(
      action: json['action'],
      distance: json['distance'].toDouble(),
      expectedHeading: json['expectedHeading']?.toDouble(),
      instruction: json['instruction'],
      point: json['point'],
    );
  }
}

// Navigation routes for different locations
final Map<String, List<Map<String, dynamic>>> locationRoutes = {
  'MAIN GATE': [
    {
      'action': 'go_straight',
      'distance': 20.0,
      'expectedHeading': 0.0,
      'instruction': 'Walk straight towards the main entrance',
    },
    {
      'action': 'turn_left',
      'distance': 15.0,
      'expectedHeading': 270.0,
      'instruction': 'Turn left at the engineering sign',
    },
  ],
  'ADMIN': [
    {
      'action': 'go_straight',
      'distance': 15.0,
      'expectedHeading': 0.0,
      'instruction': 'Walk straight towards the admin building',
    },
    {
      'action': 'turn_right',
      'distance': 20.0,
      'expectedHeading': 90.0,
      'instruction': 'Turn right at the admin building',
    },
  ],
  // Add more locations as needed
};

class NavigationOverlayWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const NavigationOverlayWidget({super.key, required this.onCheckTip});

  @override
  State<NavigationOverlayWidget> createState() =>
      _NavigationOverlayWidgetState();
}

class _NavigationOverlayWidgetState extends State<NavigationOverlayWidget> {
  final List<String> filters = [
    'All',
    'Engineering',
    'Business',
    'Natural Science',
    'Shops',
    'Parks',
    'Museums',
  ];
  int selectedFilter = 0;
  bool isNavigating = false;
  String searchQuery = '';
  Point? selectedLocation;
  bool showSearchResults = false;
  List<Point> campusLocations = [];

  // Navigation simulation variables
  late FlutterTts flutterTts;
  late AudioPlayer audioPlayer;
  double currentDistance = 150.0;
  double totalDistance = 150.0;
  Timer? distanceTimer;
  Timer? instructionTimer;
  bool isMuted = false;

  // Add these variables at the top of the class
  bool _isSpeaking = false;
  Timer? _speechTimer;
  String? _pendingInstruction;

  // Add these variables at the top of the class
  late Pedometer pedometer;
  StreamSubscription<StepCount>? stepCountStream;
  int _steps = 0;
  int _initialSteps = 0;
  double _stepLength = 0.7; // Average step length in meters
  bool _isPedometerInitialized = false;

  // Compass variables
  StreamSubscription<CompassEvent>? compassSubscription;
  double? _compassDirection;
  double? _targetDirection;
  bool _isDirectionCorrect = false;

  // Add new variables for map
  bool _showRouteMap = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLngBounds? _routeBounds;

  // Add these variables at the top of the class
  List<int> _traversedPoints = [];
  DateTime? _navigationStartTime;
  static const double _averageWalkingSpeed = 1.4; // meters per second (5 km/h)

  List<Point> get filteredLocations {
    return campusLocations.where((location) {
      final matchesSearch = location.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesSearch;
    }).toList();
  }

  void _onLocationSelected(Point location) {
    setState(() {
      selectedLocation = location;
      showSearchResults = false;
      // Calculate distance based on coordinates (simplified for now)
      totalDistance = 1000; // Default to 1km for now
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      showSearchResults = value.isNotEmpty;
      if (value.isNotEmpty) {
        selectedLocation = null; // Clear selected location when searching
      }
    });
  }

  // Updated navigation steps with specific distances and directions
  int currentStep = 0;

  // Add new variables for time tracking
  DateTime estimatedArrivalTime = DateTime.now();
  Duration remainingTime = const Duration(minutes: 14);

  List<NavigationStep> _currentRoute = [];
  int _currentStepIndex = 0;
  double _distanceTraveled = 0.0;
  double _currentHeading = 0.0;
  double _expectedHeading = 0.0;
  static const double _toleranceThreshold = 30.0;

  void _initializeNavigation(Point location) {
    final routeData = locationRoutes[location.name] ?? [];
    _currentRoute =
        routeData.map((step) => NavigationStep.fromJson(step)).toList();
    _currentStepIndex = 0;
    _distanceTraveled = 0.0;
    _expectedHeading = _currentRoute.first.expectedHeading ?? 0.0;

    // Calculate total distance and estimated time
    totalDistance =
        _currentRoute.fold(0.0, (sum, step) => sum + step.distance) *
        1000; // Convert to meters
    estimatedArrivalTime = DateTime.now().add(
      Duration(minutes: (totalDistance / 1000 * 1.5).round()),
    );
    remainingTime = Duration(minutes: (totalDistance / 1000 * 1.5).round());
  }

  bool _isFacingCorrectDirection(double current, double expected) {
    double difference = (expected - current).abs();
    if (difference > 180) {
      difference = 360 - difference;
    }
    return difference < _toleranceThreshold;
  }

  double _calculateNewHeading(double current, double angleOffset) {
    double newHeading = (current + angleOffset) % 360;
    if (newHeading < 0) {
      newHeading += 360;
    }
    return newHeading;
  }

  String _getHeadingDirectionName(double heading) {
    if ((heading >= 0 && heading < 45) || (heading > 315 && heading <= 360)) {
      return "North";
    } else if (heading >= 45 && heading < 135) {
      return "East";
    } else if (heading >= 135 && heading < 225) {
      return "South";
    } else {
      return "West";
    }
  }

  void _updateNavigation() {
    if (_currentStepIndex >= _currentRoute.length) {
      _announceArrival();
      return;
    }

    final currentPosition = LocationService.to.currentPosition.value;
    if (currentPosition == null) return;

    final currentPoint = LocationService.to.currentPoint.value;
    if (currentPoint == null) return;

    // Check if we've reached a new point in our route
    if (_currentStepIndex < _currentRoute.length) {
      final expectedPoint = _currentRoute[_currentStepIndex].point;

      // If we're at the expected point, move to the next one
      if (currentPoint.point == expectedPoint.point) {
        if (!_traversedPoints.contains(currentPoint.point)) {
          _traversedPoints.add(currentPoint.point);
        }

        _currentStepIndex++;
        if (_currentStepIndex < _currentRoute.length) {
          final nextPoint = _currentRoute[_currentStepIndex].point;
          _expectedHeading = _calculateHeading(
            currentPoint.latitude,
            currentPoint.longitude,
            nextPoint.latitude,
            nextPoint.longitude,
          );
        }
      }
    }

    // Calculate distance to next point
    double distanceToNextPoint = 0.0;
    if (_currentStepIndex < _currentRoute.length) {
      final nextPoint = _currentRoute[_currentStepIndex].point;
      distanceToNextPoint = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        nextPoint.latitude,
        nextPoint.longitude,
      );
    }

    // Calculate remaining total distance
    double remainingTotalDistance = distanceToNextPoint;
    for (int i = _currentStepIndex; i < _currentRoute.length - 1; i++) {
      final current = _currentRoute[i].point;
      final next = _currentRoute[i + 1].point;
      remainingTotalDistance += Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        next.latitude,
        next.longitude,
      );
    }

    // Calculate estimated time remaining based on walking speed
    final estimatedTimeRemaining = Duration(
      seconds: (remainingTotalDistance / _averageWalkingSpeed).round(),
    );

    // Check if we're on course with wider tolerance
    bool isOnCourse = _isFacingCorrectDirection(
      _currentHeading,
      _expectedHeading,
    );

    // Update UI state
    setState(() {
      currentDistance = remainingTotalDistance;
      remainingTime = estimatedTimeRemaining;
      estimatedArrivalTime = DateTime.now().add(estimatedTimeRemaining);
      _isDirectionCorrect = isOnCourse;
    });

    if (_currentStepIndex < _currentRoute.length) {}

    // Give voice instructions
    if (distanceToNextPoint <= 5.0) {
      if (_currentStepIndex < _currentRoute.length) {
        final nextPoint = _currentRoute[_currentStepIndex].point;
        _speakInstruction(
          "Approaching ${nextPoint.name}. ${_getNextInstruction()}",
        );
      } else {
        _speakInstruction("You have arrived at your destination");
      }
    } else if (!isOnCourse) {
      _speakInstruction(
        "Please adjust your direction to face ${_getHeadingDirectionName(_expectedHeading)}",
      );
    } else if (distanceToNextPoint <= 20.0) {
      _speakInstruction(
        "Continue straight for ${distanceToNextPoint.toStringAsFixed(0)} meters. ${_getNextInstruction()}",
      );
    }
  }

  String _getNextInstruction() {
    if (_currentStepIndex + 1 < _currentRoute.length) {
      final nextStep = _currentRoute[_currentStepIndex + 1];
      if (nextStep.expectedHeading != null) {
        final direction = _getHeadingDirectionName(nextStep.expectedHeading!);
        return "After this, you will need to turn towards $direction";
      }
    }
    return "";
  }

  void _startNavigation() async {
    if (!_isPedometerInitialized) {
      await _initializePedometer();
    }

    setState(() {
      isNavigating = true;
      _currentStepIndex = 0;
      _distanceTraveled = 0.0;
      _traversedPoints = [];
      _navigationStartTime = DateTime.now();
    });

    try {
      // Initialize audio
      await _initializeAudio();

      // Start step counting
      stepCountStream?.cancel();
      stepCountStream = Pedometer.stepCountStream.listen(
        (StepCount event) {
          if (!mounted) return;
          setState(() {
            _steps = event.steps;
            double stepsTaken = (_steps - _initialSteps).toDouble();
            _distanceTraveled = stepsTaken * _stepLength;
            _updateNavigation();
          });
        },
        onError: (error) {
          print('Error in step count stream: $error');
        },
        cancelOnError: false,
      );

      // Start compass updates
      compassSubscription?.cancel();
      compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
        if (!mounted) return;
        setState(() {
          _currentHeading = event.heading ?? 0.0;
          _updateNavigation();
        });
      });

      // Give initial instruction
      if (_currentRoute.isNotEmpty) {
        _speakInstruction("Starting navigation to ${selectedLocation?.name}");
      }
    } catch (e) {
      print('Error starting navigation: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start navigation. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _initializePedometer();
    _initializeCompass();
    _loadLocations();
    _initializeLocationService();
  }

  Future<void> _initializeAudio() async {
    flutterTts = FlutterTts();
    audioPlayer = AudioPlayer();

    // Configure TTS
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Load sound effects
    // await audioPlayer.setSource(AssetSource('sounds/turn.mp3'));
    // await audioPlayer.setSource(AssetSource('sounds/arrival.mp3'));
  }

  Future<void> _initializePedometer() async {
    try {
      // Initialize pedometer
      pedometer = Pedometer();

      // Get initial step count
      final initialCount = await Pedometer.stepCountStream.first;

      _initialSteps = initialCount.steps;
      _steps = _initialSteps;
      _isPedometerInitialized = true;

      print(
        'Pedometer initialized successfully. Initial steps: $_initialSteps',
      );
    } catch (e) {
      print('Failed to initialize pedometer: $e');
      _isPedometerInitialized = false;
    }
  }

  Future<void> _initializeCompass() async {
    try {
      // Check if compass is available
      if (await FlutterCompass.events == null) {
        print('Compass not available on this device');
        return;
      }

      // Listen to compass events
      compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
        setState(() {
          _compassDirection = event.heading;
          _checkDirection();
        });
      });
    } catch (e) {
      print('Failed to initialize compass: $e');
    }
  }

  void _checkDirection() {
    if (_compassDirection == null || _targetDirection == null) return;

    // Calculate the difference between current and target direction
    double difference = (_targetDirection! - _compassDirection!).abs();
    if (difference > 180) {
      difference = 360 - difference;
    }

    // Consider direction correct if within 15 degrees
    _isDirectionCorrect = difference <= 15;
  }

  Future<void> _speakInstruction(String instruction) async {
    if (!isMuted && !_isSpeaking) {
      try {
        _isSpeaking = true;
        await flutterTts.stop();
        await flutterTts.speak(instruction);

        // Set a timer to mark speaking as complete after a reasonable delay
        _speechTimer?.cancel();
        _speechTimer = Timer(const Duration(seconds: 3), () {
          _isSpeaking = false;
          if (_pendingInstruction != null) {
            final nextInstruction = _pendingInstruction;
            _pendingInstruction = null;
            _speakInstruction(nextInstruction!);
          }
        });
      } catch (e) {
        print('Error speaking instruction: $e');
        _isSpeaking = false;
      }
    } else if (!isMuted && _isSpeaking) {
      _pendingInstruction = instruction;
    }
  }

  Future<void> _playTurnSound() async {
    if (!isMuted) {
      try {
        // await audioPlayer.stop(); // Stop any ongoing sound
        // await audioPlayer.play(AssetSource('sounds/turn.mp3'));
      } catch (e) {
        print('Error playing turn sound: $e');
      }
    }
  }

  Future<void> _announceArrival() async {
    if (!isMuted) {
      try {
        // await flutterTts.stop();
        // await audioPlayer.stop();
        // await flutterTts.speak("You have arrived at your destination");
        // await audioPlayer.play(AssetSource('sounds/arrival.mp3'));
      } catch (e) {
        print('Error announcing arrival: $e');
      }
    }
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    if (isMuted) {
      flutterTts.stop();
      audioPlayer.stop();
    }
  }

  @override
  void dispose() {
    _speechTimer?.cancel();
    stepCountStream?.cancel();
    compassSubscription?.cancel();
    distanceTimer?.cancel();
    instructionTimer?.cancel();
    flutterTts.stop();
    audioPlayer.dispose();
    LocationService.to.stopTracking();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await loadCampusLocations(pointsIds: []);
      setState(() {
        campusLocations = locations;
      });
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  Future<void> _initializeLocationService() async {
    // Initialize the location service
    if (!Get.isRegistered<LocationService>()) {
      Get.put(LocationService());
    }

    // Start tracking location
    await LocationService.to.startTracking();

    // Listen to current point changes
    ever(LocationService.to.currentPoint, (Point? point) {
      if (point != null && mounted) {
        setState(() {
          // Update UI with current location
          if (isNavigating && selectedLocation != null) {
            // Recalculate distance to destination
            final distance = LocationService.to.getDistanceToPoint(
              selectedLocation!,
            );
            if (distance != null) {
              currentDistance = distance;
              remainingTime = Duration(
                minutes: (distance / 1000 * 1.5).round(),
              );
              estimatedArrivalTime = DateTime.now().add(remainingTime);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/city_street.jpeg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          if (isNavigating) ...[
            _buildNavigationOverlay(),
            if (_showRouteMap) _buildRouteMap(),
          ] else ...[
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.space15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    width: Get.width,
                    child: Row(
                      children: [
                        CustomSvgPicture(
                          image: MyIcons.search,
                          color: MyColor.getTextFieldHintColor(),
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomTextField(
                              hintText: 'Search for a destination',
                              animatedLabel: false,
                              fillColor: Colors.white,
                              textInputType: MyUtils.getInputTextFieldType(
                                "text",
                              ),
                              onChanged: (value) {
                                _onSearchChanged(value);
                              },
                            ),
                          ),
                        ),
                        CustomSvgPicture(
                          image: MyIcons.mic,
                          color: MyColor.getTextFieldHintColor(),
                          height: 20,
                          width: 20,
                        ),
                        horizontalSpace(Dimensions.space10),
                        CircleAvatar(
                          radius: 13,
                          child: MyLocalImageWidget(
                            imagePath: MyImages.tinder,
                            height: 26,
                            width: 26,
                            radius: 50,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final selected = selectedFilter == i;
                        return ChoiceChip(
                          label: Text(filters[i]),
                          selected: selected,
                          onSelected: (_) => setState(() => selectedFilter = i),
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.blue : Colors.black87,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          side: BorderSide(
                            color:
                                selected ? Colors.blue : Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ),
                  if (showSearchResults && filteredLocations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final location = filteredLocations[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            title: Text(location.name, style: boldDefault),
                            subtitle: Text(
                              'Point ${location.point}',
                              style: regularSmall,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)}',
                                  style: regularDefault,
                                ),
                              ],
                            ),
                            onTap: () => _onLocationSelected(location),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (selectedLocation != null) _buildLocationCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationOverlay() {
    // Determine the background color based on navigation state
    Color backgroundColor;
    if (_currentStepIndex >= _currentRoute.length) {
      backgroundColor = Colors.green.withOpacity(0.85); // Arrived
    } else if (!_isDirectionCorrect) {
      backgroundColor = Colors.red.withOpacity(0.85); // Off course
    } else {
      backgroundColor = Colors.black.withOpacity(0.85); // On course
    }

    return Stack(
      children: [
        // Top black pill
        Positioned(
          top: 60,
          left: 16,
          right: 16,
          child: Center(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      CustomSvgPicture(
                        image: _getDirectionIcon(
                          _currentHeading,
                          _expectedHeading,
                        ),
                        color: _isDirectionCorrect ? Colors.green : Colors.red,
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        '${currentDistance.toStringAsFixed(0)}m',
                        style: boldLarge.copyWith(
                          color: MyColor.getCardBgColor(),
                        ),
                      ),
                      if (_compassDirection != null)
                        Text(
                          '${_compassDirection!.toStringAsFixed(0)}°',
                          style: regularSmall.copyWith(
                            color: MyColor.getCardBgColor().withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                  horizontalSpace(Dimensions.space10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedLocation?.name ?? 'Unknown Location',
                              style: boldExtraLarge.copyWith(
                                color: MyColor.getCardBgColor(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (_currentStepIndex < _currentRoute.length)
                          Text(
                            _currentRoute[_currentStepIndex].instruction,
                            style: regularLarge.copyWith(
                              color: MyColor.getCardBgColor().withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Large Directional Arrow
        if (_currentStepIndex < _currentRoute.length)
          Center(
            child: Container(
              width: 400,
              height: 400,
              child: ModelViewer(
                backgroundColor: Colors.transparent,
                src: 'assets/models/carArrow.glb',
                alt: 'A 3D model of an arrow',
                ar: false,
                autoRotate: false,
                iosSrc:
                    'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                disableZoom: true,
              ),
            ),
          ),

        Positioned.fill(
          bottom: 0,
          child: IgnorePointer(child: CustomPaint(painter: _ARPathPainter())),
        ),
        Positioned(
          right: 18,
          bottom: 150,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isNavigating = false;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space8,
                        vertical: Dimensions.space8,
                      ),
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomSvgPicture(
                        image: MyIcons.search,
                        color: MyColor.getCardBgColor(),
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpace(Dimensions.space7),
              //call
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space8,
                        vertical: Dimensions.space8,
                      ),
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomSvgPicture(
                        image: MyIcons.speak,
                        color: MyColor.getCardBgColor(),
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpace(Dimensions.space7),
              //distance route
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: GestureDetector(
                    onTap: _showRouteOnMap,
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space8,
                        vertical: Dimensions.space8,
                      ),
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomSvgPicture(
                        image: MyIcons.distance_simple,
                        color: MyColor.getCardBgColor(),
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Center(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Arrival in ',
                            style: regularDefault.copyWith(
                              color: MyColor.getGreyText(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${remainingTime.inMinutes} min',
                            style: boldExtraLarge.copyWith(
                              color: MyColor.getHeadingTextColor(),
                            ),
                          ),
                        ],
                      ),
                      horizontalSpace(Dimensions.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'After ',
                            style: regularDefault.copyWith(
                              color: MyColor.getGreyText(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(currentDistance).toStringAsFixed(1)} m',
                            style: regularExtraLarge.copyWith(
                              color: MyColor.getHeadingTextColor().withOpacity(
                                0.75,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      horizontalSpace(Dimensions.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'At ',
                            style: regularDefault.copyWith(
                              color: MyColor.getGreyText(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${estimatedArrivalTime.hour.toString().padLeft(2, '0')}:${estimatedArrivalTime.minute.toString().padLeft(2, '0')}',
                            style: regularExtraLarge.copyWith(
                              color: MyColor.getHeadingTextColor().withOpacity(
                                0.75,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _stopNavigation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Add mute button
        Positioned(
          right: 18,
          bottom: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: _toggleMute,
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space8,
                    vertical: Dimensions.space8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up,
                    color: MyColor.getCardBgColor(),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 33,
      child: SizedBox(
        height: Get.height * 0.3,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space17,
              ),
              child: SizedBox(
                width: Get.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space30,
                      vertical: Dimensions.space15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space10,
                                vertical: Dimensions.space7,
                              ),
                              margin: const EdgeInsets.only(bottom: 0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomSvgPicture(
                                    image: MyIcons.solidTick,
                                    color: MyColor.getCardBgColor(),
                                    height: 18,
                                    width: 18,
                                  ),
                                  horizontalSpace(Dimensions.space3),
                                  Text(
                                    'Back to list',
                                    style: regularDefault.copyWith(
                                      color: MyColor.getCardBgColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            //route
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.space7,
                                    vertical: Dimensions.space7,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomSvgPicture(
                                        image: MyIcons.distance_simple,
                                        color: MyColor.getCardBgColor(),
                                        height: 18,
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(Dimensions.space7),
                            //call
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.space7,
                                    vertical: Dimensions.space7,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomSvgPicture(
                                        image: MyIcons.callCircle,
                                        color: MyColor.getCardBgColor(),
                                        height: 18,
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(Dimensions.space7),
                            //help
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.space7,
                                    vertical: Dimensions.space7,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomSvgPicture(
                                        image: MyIcons.helpCircle,
                                        color: MyColor.getCardBgColor(),
                                        height: 18,
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 18,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedLocation?.name ??
                                            'Select Destination',
                                        style: boldOverLarge.copyWith(
                                          fontSize: Dimensions.fontExtraLarge,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          CustomSvgPicture(
                                            image: MyIcons.speed_solid,
                                            color: MyColor.getGreyText(),
                                            height: 16,
                                            width: 16,
                                          ),
                                          horizontalSpace(Dimensions.space3),
                                          Text(
                                            'Current: ${LocationService.to.currentPoint.value?.name ?? 'Unknown'}',
                                            style: regularDefault.copyWith(
                                              color: MyColor.getGreyText(),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (selectedLocation != null &&
                                          LocationService
                                                  .to
                                                  .currentPoint
                                                  .value !=
                                              null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            'Distance: ${(LocationService.to.getDistanceToPoint(selectedLocation!) ?? 0).toStringAsFixed(0)}m',
                                            style: regularDefault.copyWith(
                                              color: MyColor.getGreyText(),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (selectedLocation == null ||
                                        LocationService.to.currentPoint.value ==
                                            null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please select a destination first',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Get current point and destination point IDs
                                    final currentPointId =
                                        LocationService
                                            .to
                                            .currentPoint
                                            .value!
                                            .point;
                                    final destinationPointId =
                                        selectedLocation!.point;

                                    // Find path between current location and destination
                                    List<int> path = await findPath(
                                      graph,
                                      currentPointId,
                                      destinationPointId,
                                    );

                                    if (path.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'No path found to destination',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Get route points
                                    List<Point> routePoints = await fetchRoute(
                                      pointsIds: path,
                                    );

                                    print('Route points ${path}');
                                    print('Route Coodinates ${routePoints}');

                                    if (routePoints.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to load route points',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Start navigation
                                    setState(() {
                                      isNavigating = true;
                                      _currentRoute =
                                          routePoints
                                              .map(
                                                (point) => NavigationStep(
                                                  action:
                                                      'go_straight', // Default action
                                                  distance:
                                                      0.0, // Will be calculated
                                                  expectedHeading:
                                                      null, // Will be calculated
                                                  instruction:
                                                      'Navigate to ${point.name}',
                                                  point: point,
                                                ),
                                              )
                                              .toList();

                                      // Calculate distances between points
                                      for (
                                        int i = 0;
                                        i < _currentRoute.length - 1;
                                        i++
                                      ) {
                                        final current = routePoints[i];
                                        final next = routePoints[i + 1];

                                        final distance =
                                            Geolocator.distanceBetween(
                                              current.latitude,
                                              current.longitude,
                                              next.latitude,
                                              next.longitude,
                                            );

                                        _currentRoute[i] = NavigationStep(
                                          action: _currentRoute[i].action,
                                          distance: distance,
                                          expectedHeading: _calculateHeading(
                                            current.latitude,
                                            current.longitude,
                                            next.latitude,
                                            next.longitude,
                                          ),
                                          instruction:
                                              _currentRoute[i].instruction,
                                          point: _currentRoute[i].point,
                                        );
                                      }

                                      // Update total distance and estimated time
                                      totalDistance = _currentRoute.fold(
                                        0.0,
                                        (sum, step) => sum + step.distance,
                                      );

                                      currentDistance = totalDistance;
                                      remainingTime = Duration(
                                        minutes:
                                            (totalDistance / 1000 * 1.5)
                                                .round(),
                                      );
                                      estimatedArrivalTime = DateTime.now().add(
                                        remainingTime,
                                      );

                                      // Start navigation
                                      _startNavigation();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFB6F36B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 18,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'GO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDirectionIcon(double? current, double? expected) {
    if (current == null || expected == null) return MyIcons.forward;

    double difference = (expected - current).abs();
    if (difference > 180) {
      difference = 360 - difference;
    }

    if (difference <= 15) return MyIcons.forward;
    if (difference <= 90) {
      return expected > current ? MyIcons.turnRight : MyIcons.turnLeft;
    }
    return expected > current ? MyIcons.turnRight : MyIcons.turnLeft;
  }

  double _calculateHeading(double lat1, double lon1, double lat2, double lon2) {
    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    var heading = atan2(y, x);
    heading = heading * (180 / pi);
    heading = (heading + 360) % 360;
    return heading;
  }

  void _stopNavigation() {
    setState(() {
      isNavigating = false;
      _currentStepIndex = 0;
      _distanceTraveled = 0.0;
      _traversedPoints = [];
      _navigationStartTime = null;
    });

    // Stop all audio
    flutterTts.stop();
    audioPlayer.stop();
    _isSpeaking = false;
    _pendingInstruction = null;
    _speechTimer?.cancel();

    // Stop tracking
    stepCountStream?.cancel();
    compassSubscription?.cancel();
  }

  void _showRouteOnMap() {
    if (_currentRoute.isEmpty) return;

    setState(() {
      _showRouteMap = true;
      _updateMapMarkersAndRoute();
    });
  }

  void _updateMapMarkersAndRoute() {
    if (_currentRoute.isEmpty) return;

    final markers = <Marker>{};
    final points = <LatLng>[];

    // Add current location marker
    if (LocationService.to.currentPosition.value != null) {
      final currentPos = LocationService.to.currentPosition.value!;
      markers.add(
        Marker(
          markerId: MarkerId('current'),
          position: LatLng(currentPos.latitude, currentPos.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
      points.add(LatLng(currentPos.latitude, currentPos.longitude));
    }

    // Add route points
    for (var step in _currentRoute) {
      final point = step.point;
      markers.add(
        Marker(
          markerId: MarkerId('point_${point.point}'),
          position: LatLng(point.latitude, point.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(title: point.name),
        ),
      );
      points.add(LatLng(point.latitude, point.longitude));
    }

    // Create polyline for the route with app primary color
    final polyline = Polyline(
      polylineId: PolylineId('route'),
      points: points,
      color: Color(0xFFB6F36B), // App primary color
      width: 5,
    );

    // Calculate bounds to fit all points with padding
    _routeBounds = LatLngBounds(
      southwest: LatLng(
        points.map((p) => p.latitude).reduce(min),
        points.map((p) => p.longitude).reduce(min),
      ),
      northeast: LatLng(
        points.map((p) => p.latitude).reduce(max),
        points.map((p) => p.longitude).reduce(max),
      ),
    );

    setState(() {
      _markers = markers;
      _polylines = {polyline};
    });

    // Animate camera to show the entire route with padding
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(_routeBounds!, 50),
    );
  }

  Widget _buildRouteMap() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Route Overview',
                    style: boldLarge.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showRouteMap = false;
                      });
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        LocationService.to.currentPosition.value != null
                            ? LatLng(
                              LocationService
                                  .to
                                  .currentPosition
                                  .value!
                                  .latitude,
                              LocationService
                                  .to
                                  .currentPosition
                                  .value!
                                  .longitude,
                            )
                            : LatLng(-17.3546639, 30.2071603),
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _updateMapMarkersAndRoute();
                    // Set map style to dark theme
                    controller.setMapStyle('''
                      [
                        {
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#242f3e"
                            }
                          ]
                        },
                        {
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#746855"
                            }
                          ]
                        },
                        {
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#242f3e"
                            }
                          ]
                        },
                        {
                          "featureType": "administrative.locality",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#d59563"
                            }
                          ]
                        },
                        {
                          "featureType": "poi",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#d59563"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.park",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#263c3f"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.park",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#6b9a76"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#38414e"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#212a37"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#9ca5b3"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#746855"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#1f2835"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#f3d19c"
                            }
                          ]
                        },
                        {
                          "featureType": "transit",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#2f3948"
                            }
                          ]
                        },
                        {
                          "featureType": "transit.station",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#d59563"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#17263c"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#515c6d"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#17263c"
                            }
                          ]
                        }
                      ]
                    ''');
                  },
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getElapsedTime() {
    if (_navigationStartTime == null) return '0:00';
    final elapsed = DateTime.now().difference(_navigationStartTime!);
    return _formatDuration(elapsed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}

class _ARPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient background for the main shape
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
      colors: [
        const Color(0xFF3A7BFF).withOpacity(0.6),
        const Color(0xFF3A7BFF).withOpacity(0.0),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height); // Bottom-left
    path.lineTo(size.width * 0.9, size.height); // Bottom-right
    path.lineTo(size.width * 0.6, size.height * 0.6); // Top-right
    path.lineTo(size.width * 0.5, size.height * 0.6); // Top-left
    path.close();
    canvas.drawPath(path, paint);

    // Arrow base dimensions
    final baseTop = -12.0;
    final baseBottom = 10.0;

    final startY = size.height * 0.85;
    final endY = size.height * 0.45;
    final step = size.height * 0.12;

    for (double y = startY; y > endY; y -= step) {
      final progress = (startY - y) / (startY - endY);
      final scale = 1.0 - progress * 0.6; // From 1.0 to 0.4
      final opacity = 1.0 - progress; // From 1.0 to 0.0

      final arrowPaint =
          Paint()
            ..color = Colors.white.withOpacity(opacity)
            ..style = PaintingStyle.fill;

      // Use canvas transform to scale without changing base dimensions
      canvas.save();
      canvas.translate(size.width * 0.55, y);
      canvas.scale(scale);

      final arrowPath = Path();
      arrowPath.moveTo(0, baseTop); // top center
      arrowPath.lineTo(-10, baseBottom); // bottom left
      arrowPath.lineTo(10, baseBottom); // bottom right
      arrowPath.close();

      canvas.drawPath(arrowPath, arrowPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DirectionArrowPainter extends CustomPainter {
  final Color color;

  DirectionArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    // Draw a large arrow pointing up
    final arrowWidth = size.width * 0.4;
    final arrowHeight = size.height * 0.6;
    final arrowHeadWidth = size.width * 0.6;
    final arrowHeadHeight = size.height * 0.4;

    // Arrow shaft
    path.moveTo(
      size.width / 2 - arrowWidth / 2,
      size.height / 2 + arrowHeight / 2,
    );
    path.lineTo(
      size.width / 2 + arrowWidth / 2,
      size.height / 2 + arrowHeight / 2,
    );
    path.lineTo(
      size.width / 2 + arrowWidth / 2,
      size.height / 2 - arrowHeight / 2,
    );
    path.lineTo(
      size.width / 2 - arrowWidth / 2,
      size.height / 2 - arrowHeight / 2,
    );
    path.close();

    // Arrow head
    path.moveTo(
      size.width / 2 - arrowHeadWidth / 2,
      size.height / 2 - arrowHeight / 2,
    );
    path.lineTo(
      size.width / 2,
      size.height / 2 - arrowHeight / 2 - arrowHeadHeight,
    );
    path.lineTo(
      size.width / 2 + arrowHeadWidth / 2,
      size.height / 2 - arrowHeight / 2,
    );
    path.close();

    canvas.drawPath(path, paint);

    // Add a circular background
    final circlePaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.45,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
