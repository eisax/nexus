import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/scan/widget/phoneScanTipWidget.dart';
import 'package:nexus/ui/screens/scan/widget/scanScreenWidget.dart';

class ScanCameraView extends StatefulWidget {
  const ScanCameraView({super.key});

  @override
  _ScanCameraViewState createState() => _ScanCameraViewState();
}

class _ScanCameraViewState extends State<ScanCameraView>
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
