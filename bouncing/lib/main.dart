import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Staggered Animation - Bouncing'),
        ),
        backgroundColor: Colors.teal.shade100,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const BouncingAnimationWidget(),
        ),
      );
}

class BouncingAnimationWidget extends StatefulWidget {
  const BouncingAnimationWidget({Key? key}) : super(key: key);

  @override
  State<BouncingAnimationWidget> createState() =>
      _BouncingAnimationWidgetState();
}

class _BouncingAnimationWidgetState extends State<BouncingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _boxJumpHeight;
  late final Animation<double> _boxWidth;
  late final Animation<double> _boxShadowWidth;
  late final Animation<double> _boxShadowIntensity;
  late final Animation<double> _boxRotationAngle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initJumpAnimation();
    _initBoxWidthAnimation();
    _initBoxShadowWidthAnimation();
    _initBoxShadowIntensityAnimation();
    _initBoxRotationAnimation();
  }

  void _initJumpAnimation() => _boxJumpHeight = Tween<double>(
        begin: -0.07,
        end: -0.5,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.0,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );

  void _initBoxRotationAnimation() => _boxRotationAngle = Tween<double>(
        begin: 0,
        end: 360,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.25,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );

  void _initBoxWidthAnimation() => _boxWidth = Tween<double>(
        begin: 160,
        end: 50,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.05,
            0.3,
            curve: Curves.ease,
          ),
        ),
      );

  void _initBoxShadowWidthAnimation() => _boxShadowWidth = Tween<double>(
        begin: 180,
        end: 50,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.05,
            0.5,
            curve: Curves.ease,
          ),
        ),
      );

  void _initBoxShadowIntensityAnimation() =>
      _boxShadowIntensity = Tween<double>(
        begin: 0.15,
        end: 0.05,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.05,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        builder: (context, _) => _buildAnimation(context),
        animation: _controller,
      );

  Widget _buildAnimation(BuildContext context) => GestureDetector(
        onTap: _playAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _boxShadow(context),
            Align(
              alignment: Alignment(0.0, _boxJumpHeight.value),
              child: _animatedBox(context),
            ),
          ],
        ),
      );

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled
    }
  }

  Widget _boxShadow(BuildContext context) => Container(
        width: _boxShadowWidth.value,
        height: 15,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.elliptical(_boxShadowWidth.value, 15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_boxShadowIntensity.value),
              spreadRadius: 5,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      );

  Widget _animatedBox(BuildContext context) => Transform(
        alignment: Alignment.center,
        transform: _boxRotation(_controller.status),
        child: Container(
          width: _boxWidth.value,
          height: 50,
          color: Colors.white,
        ),
      );

  Matrix4 _boxRotation(AnimationStatus animationStatus) {
    // This will ensure that rotation will be in the same direction on reverse
    if (animationStatus == AnimationStatus.reverse) {
      return Matrix4.identity()..rotateZ(-_boxRotationAngle.value * pi / 180);
    } else {
      return Matrix4.identity()..rotateZ(_boxRotationAngle.value * pi / 180);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
