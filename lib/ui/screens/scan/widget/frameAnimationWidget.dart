import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus/ui/screens/scan/scan_screen.dart';

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
