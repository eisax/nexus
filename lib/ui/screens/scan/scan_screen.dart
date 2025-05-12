import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus/app/routes.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();

  static Widget routeInstance() {
    return const ScanScreen();
  }
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProjectListPage();
  }
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with WidgetsBindingObserver {
  bool isTipActive = true;
  CameraController? controller;
  bool enableAudio = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    await _initializeCameraController(firstCamera);
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        ...!kIsWeb
            ? <Future<Object?>>[
              cameraController.getMinExposureOffset().then(
                (double value) => _minAvailableExposureOffset = value,
              ),
              cameraController.getMaxExposureOffset().then(
                (double value) => _maxAvailableExposureOffset = value,
              ),
            ]
            : <Future<Object?>>[],
        cameraController.getMaxZoomLevel().then(
          (double value) => _maxAvailableZoom = value,
        ),
        cameraController.getMinZoomLevel().then(
          (double value) => _minAvailableZoom = value,
        ),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          print('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          print('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          print('Camera access is restricted.');
        case 'AudioAccessDenied':
          print('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          print('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          print('Audio access is restricted.');
        default:
          _showCameraException(e);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    print('CameraException: ${e.code} - ${e.description}');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Stack(
        children: [
          controller != null && controller!.value.isInitialized
              ? SizedBox(
                width: Get.width,
                height: Get.height,
                child: CameraPreview(controller!),
              )
              : Container(
                width: Get.width,
                height: Get.height,
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator()),
              ),
          Positioned(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  isTipActive
                      ? PhoneScanTipWidget(
                        scale: 1,
                        key: const ValueKey('tip'),
                        onReady: () {
                          setState(() {
                            isTipActive = false;
                          });
                        },
                      )
                      : ScanScreenWidget(
                        key: const ValueKey('readyToGo'),
                        onCheckTip: () {
                          setState(() {
                            isTipActive = true;
                          });
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

// Rest of your code remains the same...

class ScanScreenWidget extends StatefulWidget {
  final void Function() onCheckTip;
  const ScanScreenWidget({super.key, required this.onCheckTip});

  @override
  State<ScanScreenWidget> createState() => _ScanScreenWidgetState();
}

class _ScanScreenWidgetState extends State<ScanScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: InkWell(
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
                          onTap: ()=>Get.back(),
                          child: Container(
                            height: 30,
                            width: 30,

                            decoration: BoxDecoration(shape: BoxShape.circle),
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
                                color: const Color.from(
                                  alpha: 0.545,
                                  red: 1,
                                  green: 1,
                                  blue: 1,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                 onTap: widget.onCheckTip,
                                
                                child: Container(
                                  color: const Color.from(
                                    alpha: 0.55,
                                    red: 0,
                                    green: 0,
                                    blue: 0,
                                  ),
                                  child: FrameAnimation(width: 75, height: 100),
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Image.asset(
                      "assets/images/shoot_icon.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: ()=>Get.toNamed(RouteHelper.overview),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.from(
                          alpha: 0.75,
                          red: 0,
                          green: 0,
                          blue: 0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Aim the dot",
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                        onTap: widget.onCheckTip,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
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
                      const Text(
                        "0/100",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneScanTipWidget extends StatefulWidget {
  final void Function() onReady;
  final double scale;
  const PhoneScanTipWidget({super.key, required this.onReady, this.scale = 1});

  @override
  State<PhoneScanTipWidget> createState() => _PhoneScanTipWidgetState();
}

class _PhoneScanTipWidgetState extends State<PhoneScanTipWidget> {
  bool _doNotRemindMe = false;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: InkWell(
          child: Stack(
            children: [
              Positioned.fill(
                top: Get.height / 3 - 72,
                child: Column(
                  children: [
                    FrameAnimation(
                      width: Get.width * 0.75,
                      height: Get.width * 0.75,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Fix phone position, to align the phone. Use a gimble for better results",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Keep your phone steady when positioning to improve 3D tour image quality.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: widget.onReady,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "Ready to go",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.75,
                              child: Checkbox(
                                checkColor: Colors.white,
                                visualDensity: const VisualDensity(
                                  horizontal: -4.0,
                                  vertical: -4.0,
                                ),
                                value: _doNotRemindMe,
                                onChanged: (value) {
                                  setState(() {
                                    _doNotRemindMe = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 0),
                            const Text(
                              "Do not remind again",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FrameAnimation extends StatefulWidget {
  final double width;
  final double height;
  const FrameAnimation({super.key, required this.width, required this.height});

  @override
  _FrameAnimationState createState() => _FrameAnimationState();
}

class _FrameAnimationState extends State<FrameAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _frameAnimation;

  final int startFrame = 269;
  final int endFrame = 606;
  final Map<int, AssetImage> _frameImages = {};

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _frameAnimation = IntTween(
      begin: startFrame,
      end: endFrame,
    ).animate(_controller)..addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (int i = startFrame; i <= endFrame; i++) {
      final asset = AssetImage(
        'assets/images/phone_shoot_long_after/phone_shoot_$i.png',
      );
      _frameImages[i] = asset;
      precacheImage(asset, context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = _frameAnimation.value;
    final image = _frameImages[currentFrame];

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child:
            image != null
                ? Image(image: image, gaplessPlayback: true, fit: BoxFit.fill)
                : const SizedBox(),
      ),
    );
  }
}
