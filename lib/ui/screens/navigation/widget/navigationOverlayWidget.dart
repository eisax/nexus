import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
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

class CampusLocation {
  final String name;
  final String department;
  final String image;
  final double rating;
  final String description;
  final double distance;
  final int estimatedTime;

  CampusLocation({
    required this.name,
    required this.department,
    required this.image,
    required this.rating,
    required this.description,
    required this.distance,
    required this.estimatedTime,
  });
}

class NavigationOverlayWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const NavigationOverlayWidget({super.key, required this.onCheckTip});

  @override
  State<NavigationOverlayWidget> createState() => _NavigationOverlayWidgetState();
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
  CampusLocation? selectedLocation;
  bool showSearchResults = false;
  
  // Navigation simulation variables
  late FlutterTts flutterTts;
  late AudioPlayer audioPlayer;
  double currentDistance = 150.0;
  double totalDistance = 150.0;
  Timer? distanceTimer;
  Timer? instructionTimer;
  bool isMuted = false;

  // Add these variables at the top of the class
  late Pedometer pedometer;
  StreamSubscription<StepCount>? stepCountStream;
  int _steps = 0;
  int _initialSteps = 0;
  double _stepLength = 0.7; // Average step length in meters
  bool _isPedometerInitialized = false;

  // Campus locations data
  final List<CampusLocation> campusLocations = [
    // Engineering Department
    CampusLocation(
      name: 'Engineering Building',
      department: 'Engineering',
      image: MyImages.library,
      rating: 4.5,
      description: 'Main engineering department building with state-of-the-art labs',
      distance: 1.3,
      estimatedTime: 17,
    ),
    CampusLocation(
      name: 'Robotics Lab',
      department: 'Engineering',
      image: MyImages.library,
      rating: 4.7,
      description: 'Advanced robotics research and development facility',
      distance: 1.4,
      estimatedTime: 18,
    ),
    CampusLocation(
      name: 'Computer Science Department',
      department: 'Engineering',
      image: MyImages.library,
      rating: 4.6,
      description: 'Computer science labs and lecture halls',
      distance: 1.2,
      estimatedTime: 15,
    ),
    CampusLocation(
      name: 'Engineering Workshop',
      department: 'Engineering',
      image: MyImages.library,
      rating: 4.4,
      description: 'Student workshop with modern equipment',
      distance: 1.5,
      estimatedTime: 19,
    ),
    CampusLocation(
      name: 'Engineering Dean\'s Office',
      department: 'Engineering',
      image: MyImages.library,
      rating: 4.3,
      description: 'Administrative offices for engineering faculty',
      distance: 1.3,
      estimatedTime: 17,
    ),

    // Business Department
    CampusLocation(
      name: 'Business School',
      department: 'Business',
      image: MyImages.library,
      rating: 4.3,
      description: 'Modern business school with conference facilities',
      distance: 0.8,
      estimatedTime: 10,
    ),
    CampusLocation(
      name: 'Finance Department',
      department: 'Business',
      image: MyImages.library,
      rating: 4.4,
      description: 'Finance and accounting department offices',
      distance: 0.9,
      estimatedTime: 11,
    ),
    CampusLocation(
      name: 'Business Incubator',
      department: 'Business',
      image: MyImages.library,
      rating: 4.8,
      description: 'Startup incubation center for student entrepreneurs',
      distance: 0.7,
      estimatedTime: 9,
    ),
    CampusLocation(
      name: 'Business Library',
      department: 'Business',
      image: MyImages.library,
      rating: 4.5,
      description: 'Specialized business resources and study spaces',
      distance: 0.8,
      estimatedTime: 10,
    ),
    CampusLocation(
      name: 'Business Career Center',
      department: 'Business',
      image: MyImages.library,
      rating: 4.6,
      description: 'Career services and internship opportunities',
      distance: 0.9,
      estimatedTime: 11,
    ),

    // Natural Science Department
    CampusLocation(
      name: 'Science Center',
      department: 'Natural Science',
      image: MyImages.library,
      rating: 4.7,
      description: 'Research laboratories and lecture halls',
      distance: 1.5,
      estimatedTime: 20,
    ),
    CampusLocation(
      name: 'Biology Lab',
      department: 'Natural Science',
      image: MyImages.library,
      rating: 4.6,
      description: 'Advanced biology research facilities',
      distance: 1.6,
      estimatedTime: 21,
    ),
    CampusLocation(
      name: 'Chemistry Lab',
      department: 'Natural Science',
      image: MyImages.library,
      rating: 4.5,
      description: 'State-of-the-art chemistry laboratories',
      distance: 1.4,
      estimatedTime: 18,
    ),
    CampusLocation(
      name: 'Physics Department',
      department: 'Natural Science',
      image: MyImages.library,
      rating: 4.7,
      description: 'Physics research and teaching facilities',
      distance: 1.5,
      estimatedTime: 19,
    ),
    CampusLocation(
      name: 'Science Library',
      department: 'Natural Science',
      image: MyImages.library,
      rating: 4.4,
      description: 'Specialized science resources and study areas',
      distance: 1.3,
      estimatedTime: 17,
    ),

    // Shops
    CampusLocation(
      name: 'Campus Bookstore',
      department: 'Shops',
      image: MyImages.library,
      rating: 4.2,
      description: 'Textbooks, supplies, and university merchandise',
      distance: 0.5,
      estimatedTime: 7,
    ),
    CampusLocation(
      name: 'Campus Cafe',
      department: 'Shops',
      image: MyImages.library,
      rating: 4.5,
      description: 'Coffee shop and light meals',
      distance: 0.4,
      estimatedTime: 5,
    ),
    CampusLocation(
      name: 'Student Store',
      department: 'Shops',
      image: MyImages.library,
      rating: 4.3,
      description: 'General supplies and snacks',
      distance: 0.6,
      estimatedTime: 8,
    ),
    CampusLocation(
      name: 'Print Shop',
      department: 'Shops',
      image: MyImages.library,
      rating: 4.1,
      description: 'Printing and copying services',
      distance: 0.7,
      estimatedTime: 9,
    ),
    CampusLocation(
      name: 'Tech Store',
      department: 'Shops',
      image: MyImages.library,
      rating: 4.4,
      description: 'Electronics and computer supplies',
      distance: 0.5,
      estimatedTime: 7,
    ),

    // Parks
    CampusLocation(
      name: 'Central Park',
      department: 'Parks',
      image: MyImages.library,
      rating: 4.8,
      description: 'Beautiful green space for relaxation and study',
      distance: 0.3,
      estimatedTime: 5,
    ),
    CampusLocation(
      name: 'Botanical Garden',
      department: 'Parks',
      image: MyImages.library,
      rating: 4.7,
      description: 'Research garden with diverse plant species',
      distance: 0.4,
      estimatedTime: 6,
    ),
    CampusLocation(
      name: 'Sports Field',
      department: 'Parks',
      image: MyImages.library,
      rating: 4.6,
      description: 'Athletic facilities and open space',
      distance: 0.5,
      estimatedTime: 7,
    ),
    CampusLocation(
      name: 'Memorial Garden',
      department: 'Parks',
      image: MyImages.library,
      rating: 4.5,
      description: 'Peaceful garden for reflection',
      distance: 0.2,
      estimatedTime: 3,
    ),
    CampusLocation(
      name: 'Fountain Square',
      department: 'Parks',
      image: MyImages.library,
      rating: 4.4,
      description: 'Central gathering space with water features',
      distance: 0.3,
      estimatedTime: 4,
    ),

    // Museums
    CampusLocation(
      name: 'University Museum',
      department: 'Museums',
      image: MyImages.library,
      rating: 4.6,
      description: 'Historical artifacts and art exhibitions',
      distance: 1.0,
      estimatedTime: 13,
    ),
    CampusLocation(
      name: 'Art Gallery',
      department: 'Museums',
      image: MyImages.library,
      rating: 4.7,
      description: 'Contemporary and classical art exhibitions',
      distance: 1.1,
      estimatedTime: 14,
    ),
    CampusLocation(
      name: 'Science Museum',
      department: 'Museums',
      image: MyImages.library,
      rating: 4.5,
      description: 'Interactive science exhibits',
      distance: 0.9,
      estimatedTime: 12,
    ),
    CampusLocation(
      name: 'History Museum',
      department: 'Museums',
      image: MyImages.library,
      rating: 4.4,
      description: 'University and local history exhibits',
      distance: 1.2,
      estimatedTime: 15,
    ),
    CampusLocation(
      name: 'Cultural Center',
      department: 'Museums',
      image: MyImages.library,
      rating: 4.6,
      description: 'Cultural exhibitions and events',
      distance: 1.0,
      estimatedTime: 13,
    ),
  ];

  List<CampusLocation> get filteredLocations {
    return campusLocations.where((location) {
      final matchesSearch = location.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          location.department.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == 0 || location.department == filters[selectedFilter];
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _onLocationSelected(CampusLocation location) {
    setState(() {
      selectedLocation = location;
      showSearchResults = false;
      totalDistance = location.distance * 1000; // Convert km to meters
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
  
  // Navigation instructions
  final List<Map<String, dynamic>> navigationSteps = [
    {'distance': 150, 'instruction': 'Turn left after 150 meters', 'icon': MyIcons.turnLeft},
    {'distance': 100, 'instruction': 'Continue straight for 100 meters', 'icon': MyIcons.forward},
    {'distance': 50, 'instruction': 'Turn right after 50 meters', 'icon': MyIcons.turnRight},
    {'distance': 25, 'instruction': 'Your destination is on the right', 'icon': MyIcons.turnRight},
  ];
  int currentStep = 0;

  // Add new variables for time tracking
  DateTime estimatedArrivalTime = DateTime.now();
  Duration remainingTime = const Duration(minutes: 14);

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _initializePedometer();
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
    await audioPlayer.setSource(AssetSource('sounds/turn.mp3'));
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
      
      print('Pedometer initialized successfully. Initial steps: $_initialSteps');
    } catch (e) {
      print('Failed to initialize pedometer: $e');
      _isPedometerInitialized = false;
    }
  }

  void _startNavigation() async {
    if (!_isPedometerInitialized) {
      await _initializePedometer();
    }

    setState(() {
      isNavigating = true;
      currentDistance = totalDistance;
      currentStep = 0;
    });

    try {
      // Start listening to step count
      stepCountStream?.cancel(); // Cancel any existing stream
      stepCountStream = Pedometer.stepCountStream.listen(
        (StepCount event) {
          print('Step count updated: ${event.steps}'); // Debug log
          setState(() {
            _steps = event.steps;
            // Calculate distance based on steps
            double stepsTaken = (_steps - _initialSteps).toDouble();
            currentDistance = totalDistance - (stepsTaken * _stepLength);
            
            // Update remaining time based on steps (assuming 100 steps per minute)
            remainingTime = Duration(minutes: (stepsTaken / 100).round());
            
            // Check if we need to give next instruction
            if (currentStep < navigationSteps.length - 1 && 
                currentDistance <= navigationSteps[currentStep + 1]['distance']) {
              _giveNextInstruction();
            }

            // Check if destination reached
            if (currentDistance <= 0) {
              stepCountStream?.cancel();
              _announceArrival();
            }
          });
        },
        onError: (error) {
          print('Error in step count stream: $error');
        },
        cancelOnError: false,
      );

      // Give initial instruction
      _speakInstruction(navigationSteps[0]['instruction']);
    } catch (e) {
      print('Error starting navigation: $e');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start step counting. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _giveNextInstruction() {
    currentStep++;
    _speakInstruction(navigationSteps[currentStep]['instruction']);
    _playTurnSound();
  }

  Future<void> _speakInstruction(String instruction) async {
    if (!isMuted) {
      await flutterTts.speak(instruction);
    }
  }

  Future<void> _playTurnSound() async {
    if (!isMuted) {
      await audioPlayer.play(AssetSource('sounds/turn.mp3'));
    }
  }

  Future<void> _announceArrival() async {
    if (!isMuted) {
      await flutterTts.speak("You have arrived at your destination");
      await audioPlayer.play(AssetSource('sounds/arrival.mp3'));
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
    stepCountStream?.cancel();
    distanceTimer?.cancel();
    instructionTimer?.cancel();
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/city_street.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          if (isNavigating) ...[
            _buildNavigationOverlay(),
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
                              textInputType: MyUtils.getInputTextFieldType("text"),
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
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          side: BorderSide(
                            color: selected ? Colors.blue : Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ),
                  if (showSearchResults && filteredLocations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: Get.height * 0.4,
                      ),
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
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: MyLocalImageWidget(
                                imagePath: location.image,
                                height: 50,
                                width: 50,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              location.name,
                              style: boldDefault,
                            ),
                            subtitle: Text(
                              location.department,
                              style: regularSmall,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomSvgPicture(
                                  image: MyIcons.star,
                                  color: Colors.amber,
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  location.rating.toString(),
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

            if (selectedLocation != null)
              Positioned(
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
                          child: MyLocalImageWidget(
                            imagePath: selectedLocation!.image,
                            boxFit: BoxFit.fill,
                            radius: 28,
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
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
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
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions.space7,
                                              vertical: Dimensions.space7,
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.55,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                32,
                                              ),
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
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions.space7,
                                              vertical: Dimensions.space7,
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.55,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                32,
                                              ),
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
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions.space7,
                                              vertical: Dimensions.space7,
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.55,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                32,
                                              ),
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
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                  alignment: WrapAlignment.center,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      selectedLocation!.name,
                                                      style: boldOverLarge.copyWith(
                                                        fontSize: Dimensions.fontExtraLarge,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    CustomSvgPicture(
                                                      image: MyIcons.star,
                                                      color: Colors.amber,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    horizontalSpace(Dimensions.space7),
                                                    Text(
                                                      selectedLocation!.rating.toString(),
                                                      style: regularExtraLarge.copyWith(
                                                        color: MyColor.getGreyText(),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
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
                                                      'Est. ${selectedLocation!.estimatedTime} min',
                                                      style: regularDefault.copyWith(
                                                        color: MyColor.getGreyText(),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '${selectedLocation!.distance} km',
                                                      style: regularDefault.copyWith(
                                                        color: MyColor.getGreyText(),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 18,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _startNavigation,
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
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationOverlay() {
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
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      CustomSvgPicture(
                        image: navigationSteps[currentStep]['icon'],
                        color: MyColor.getTextFieldHintColor(),
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        '${currentDistance.toStringAsFixed(0)}m',
                        style: boldLarge.copyWith(
                          color: MyColor.getCardBgColor(),
                        ),
                      ),
                    ],
                  ),
                  horizontalSpace(Dimensions.space10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Dining Hall',
                            style: boldExtraLarge.copyWith(
                              color: MyColor.getCardBgColor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        navigationSteps[currentStep]['instruction'],
                        style: regularLarge.copyWith(
                          color: MyColor.getCardBgColor().withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Blue AR path with arrows (placeholder)
        Positioned.fill(
          bottom: 0,
          child: IgnorePointer(child: CustomPaint(painter: _ARPathPainter())),
        ),
        // Floating round action buttons
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
              //help
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
                              color: MyColor.getHeadingTextColor().withOpacity(0.75),
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
                              color: MyColor.getHeadingTextColor().withOpacity(0.75),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isNavigating = false;
                        distanceTimer?.cancel();
                        flutterTts.stop();
                        audioPlayer.stop();
                      });
                    },
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
