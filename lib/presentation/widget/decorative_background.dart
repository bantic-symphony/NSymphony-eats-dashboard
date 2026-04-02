import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nsymphony_eats_dashboard/core/constants/app_constants.dart';

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
      duration: const Duration(seconds: AppConstants.bgRotation1Duration),
      vsync: this,
    )..repeat();

    _rotationController2 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgRotation2Duration),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController3 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgRotation3Duration),
      vsync: this,
    )..repeat();

    _rotationController4 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgRotation4Duration),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController5 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgRotation5Duration),
      vsync: this,
    )..repeat();

    // Movement controllers
    _movementController1 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgMovement1Duration),
      vsync: this,
    )..repeat();

    _movementController2 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgMovement2Duration),
      vsync: this,
    )..repeat();

    _movementController3 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgMovement3Duration),
      vsync: this,
    )..repeat();

    _movementController4 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgMovement4Duration),
      vsync: this,
    )..repeat();

    _movementController5 = AnimationController(
      duration: const Duration(seconds: AppConstants.bgMovement5Duration),
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
            final offsetX = AppConstants.bgShape1OffsetX * math.cos(angle);
            final offsetY = AppConstants.bgShape1OffsetY * math.sin(angle);
            return Positioned(
              top: AppConstants.bgShape1Top + offsetY,
              left: AppConstants.bgShape1Left + offsetX,
              child: RotationTransition(
                turns: _rotationController1,
                child: Opacity(
                  opacity: AppConstants.bgShape1Opacity,
                  child: Image.asset(
                    AppConstants.shapeYellowStripes,
                    width: AppConstants.bgShape1Size,
                    height: AppConstants.bgShape1Size,
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
            final offsetY = AppConstants.bgShape2OffsetY * math.sin(angle);
            final offsetX = AppConstants.bgShape2OffsetX * math.cos(angle);
            return Positioned(
              top: AppConstants.bgShape2Top + offsetY,
              right: AppConstants.bgShape2Right + offsetX,
              child: RotationTransition(
                turns: Tween<double>(begin: 1.0, end: 0.0).animate(_rotationController2),
                child: Opacity(
                  opacity: AppConstants.bgShape2Opacity,
                  child: Image.asset(
                    AppConstants.shapePurpleCircles,
                    width: AppConstants.bgShape2Size,
                    height: AppConstants.bgShape2Size,
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
            final offsetX = AppConstants.bgShape3OffsetX * math.sin(angle);
            final offsetY = AppConstants.bgShape3OffsetY * math.cos(angle);
            return Positioned(
              bottom: AppConstants.bgShape3Bottom + offsetY,
              left: AppConstants.bgShape3Left + offsetX,
              child: RotationTransition(
                turns: _rotationController3,
                child: Opacity(
                  opacity: AppConstants.bgShape3Opacity,
                  child: Image.asset(
                    AppConstants.shapeCoralCurves,
                    width: AppConstants.bgShape3Size,
                    height: AppConstants.bgShape3Size,
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
            final offsetX = AppConstants.bgShape4OffsetX * math.cos(angle + math.pi / 4);
            final offsetY = AppConstants.bgShape4OffsetY * math.sin(angle + math.pi / 4);
            return Positioned(
              bottom: AppConstants.bgShape4Bottom + offsetY,
              right: AppConstants.bgShape4Right + offsetX,
              child: RotationTransition(
                turns: Tween<double>(begin: 1.0, end: 0.0).animate(_rotationController4),
                child: Opacity(
                  opacity: AppConstants.bgShape4Opacity,
                  child: Image.asset(
                    AppConstants.shapeYellowCurves,
                    width: AppConstants.bgShape4Size,
                    height: AppConstants.bgShape4Size,
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
            final offsetX = AppConstants.bgShape5OffsetX * math.cos(angle);
            final offsetY = AppConstants.bgShape5OffsetY * math.sin(angle);
            return Positioned(
              top: size.height * AppConstants.bgShape5TopFactor + offsetY,
              left: size.width * AppConstants.bgShape5LeftFactor + offsetX,
              child: RotationTransition(
                turns: _rotationController5,
                child: Opacity(
                  opacity: AppConstants.bgShape5Opacity,
                  child: Image.asset(
                    AppConstants.shapeCoralSemicircle,
                    width: AppConstants.bgShape5Size,
                    height: AppConstants.bgShape5Size,
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
