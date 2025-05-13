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
  bool _isCameraInitializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
      controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (_isCameraInitializing) return;
    _isCameraInitializing = true;

    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      await _initializeCameraController(firstCamera);
    } catch (e) {
      print("Failed to initialize camera: $e");
    } finally {
      _isCameraInitializing = false;
    }
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();

      if (!kIsWeb) {
        _minAvailableExposureOffset =
            await cameraController.getMinExposureOffset();
        _maxAvailableExposureOffset =
            await cameraController.getMaxExposureOffset();
      }

      _maxAvailableZoom = await cameraController.getMaxZoomLevel();
      _minAvailableZoom = await cameraController.getMinZoomLevel();

      if (mounted) setState(() {});
    } on CameraException catch (e) {
      _showCameraException(e);
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
