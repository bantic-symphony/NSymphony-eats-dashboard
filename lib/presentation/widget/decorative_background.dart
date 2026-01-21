import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated decorative background shapes widget for the dashboard
class DecorativeBackground extends StatefulWidget {
  const DecorativeBackground({super.key});

  @override
  State<DecorativeBackground> createState() => _DecorativeBackgroundState();
}

class _DecorativeBackgroundState extends State<DecorativeBackground>
    with TickerProviderStateMixin {
  // Rotation controllers
  late AnimationController _rotationController1;
  late AnimationController _rotationController2;
  late AnimationController _rotationController3;
  late AnimationController _rotationController4;
  late AnimationController _rotationController5;

  // Movement controllers for position animations
  late AnimationController _movementController1;
  late AnimationController _movementController2;
  late AnimationController _movementController3;
  late AnimationController _movementController4;
  late AnimationController _movementController5;

  @override
  void initState() {
    super.initState();

    // Rotation controllers
    _rotationController1 = AnimationController(
      duration: const Duration(seconds: 80),
      vsync: this,
    )..repeat();

    _rotationController2 = AnimationController(
      duration: const Duration(seconds: 70),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController3 = AnimationController(
      duration: const Duration(seconds: 100),
      vsync: this,
    )..repeat();

    _rotationController4 = AnimationController(
      duration: const Duration(seconds: 75),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController5 = AnimationController(
      duration: const Duration(seconds: 90),
      vsync: this,
    )..repeat();

    // Movement controllers
    _movementController1 = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    )..repeat();

    _movementController2 = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();

    _movementController3 = AnimationController(
      duration: const Duration(seconds: 55),
      vsync: this,
    )..repeat();

    _movementController4 = AnimationController(
      duration: const Duration(seconds: 65),
      vsync: this,
    )..repeat();

    _movementController5 = AnimationController(
      duration: const Duration(seconds: 70),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController1.dispose();
    _rotationController2.dispose();
    _rotationController3.dispose();
    _rotationController4.dispose();
    _rotationController5.dispose();
    _movementController1.dispose();
    _movementController2.dispose();
    _movementController3.dispose();
    _movementController4.dispose();
    _movementController5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Top-left: Yellow stripes (clockwise, circular movement)
        AnimatedBuilder(
          animation: _movementController1,
          builder: (context, child) {
            final angle = _movementController1.value * 2 * math.pi;
            final offsetX = 40 * math.cos(angle);
            final offsetY = 50 * math.sin(angle);
            return Positioned(
              top: 40 + offsetY,
              left: 50 + offsetX,
              child: RotationTransition(
                turns: _rotationController1,
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/shapes/shape_yellow_stripes.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            );
          },
        ),

        // Top-right: Purple circles (counter-clockwise, vertical wave movement)
        AnimatedBuilder(
          animation: _movementController2,
          builder: (context, child) {
            final angle = _movementController2.value * 2 * math.pi;
            final offsetY = 60 * math.sin(angle);
            final offsetX = 30 * math.cos(angle);
            return Positioned(
              top: 60 + offsetY,
              right: 100 + offsetX,
              child: RotationTransition(
                turns: Tween<double>(begin: 1.0, end: 0.0).animate(_rotationController2),
                child: Opacity(
                  opacity: 0.12,
                  child: Image.asset(
                    'assets/images/shapes/shape_purple_circles.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
            );
          },
        ),

        // Bottom-left: Coral curves (clockwise, horizontal wave movement)
        AnimatedBuilder(
          animation: _movementController3,
          builder: (context, child) {
            final angle = _movementController3.value * 2 * math.pi;
            final offsetX = 70 * math.sin(angle);
            final offsetY = 40 * math.cos(angle);
            return Positioned(
              bottom: 80 + offsetY,
              left: 60 + offsetX,
              child: RotationTransition(
                turns: _rotationController3,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/shapes/shape_coral_curves.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            );
          },
        ),

        // Bottom-right: Yellow curves (counter-clockwise, diagonal movement)
        AnimatedBuilder(
          animation: _movementController4,
          builder: (context, child) {
            final angle = _movementController4.value * 2 * math.pi;
            final offsetX = 50 * math.cos(angle + math.pi / 4);
            final offsetY = 50 * math.sin(angle + math.pi / 4);
            return Positioned(
              bottom: 60 + offsetY,
              right: 80 + offsetX,
              child: RotationTransition(
                turns: Tween<double>(begin: 1.0, end: 0.0).animate(_rotationController4),
                child: Opacity(
                  opacity: 0.13,
                  child: Image.asset(
                    'assets/images/shapes/shape_yellow_curves.png',
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
            );
          },
        ),

        // Center: Coral semicircle (clockwise, elliptical movement)
        AnimatedBuilder(
          animation: _movementController5,
          builder: (context, child) {
            final angle = _movementController5.value * 2 * math.pi;
            final offsetX = 60 * math.cos(angle);
            final offsetY = 80 * math.sin(angle);
            return Positioned(
              top: size.height * 0.4 + offsetY,
              left: size.width * 0.25 + offsetX,
              child: RotationTransition(
                turns: _rotationController5,
                child: Opacity(
                  opacity: 0.08,
                  child: Image.asset(
                    'assets/images/shapes/shape_coral_semicircle.png',
                    width: 220,
                    height: 220,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
