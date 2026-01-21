import 'package:flutter/material.dart';

/// Animated decorative background shapes widget for the dashboard
class DecorativeBackground extends StatefulWidget {
  const DecorativeBackground({super.key});

  @override
  State<DecorativeBackground> createState() => _DecorativeBackgroundState();
}

class _DecorativeBackgroundState extends State<DecorativeBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;

  @override
  void initState() {
    super.initState();

    // Different durations for each shape for varied animation
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat(reverse: true);

    _controller4 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);

    _controller5 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Top-left: Yellow stripes (rotating slowly)
        AnimatedBuilder(
          animation: _controller1,
          builder: (context, child) {
            return Positioned(
              top: 40,
              left: 50,
              child: Transform.rotate(
                angle: _controller1.value * 0.2, // Subtle rotation
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

        // Top-right: Purple circles (floating up/down)
        AnimatedBuilder(
          animation: _controller2,
          builder: (context, child) {
            return Positioned(
              top: 60 + (_controller2.value * 20),
              right: 100,
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/shapes/shape_purple_circles.png',
                  width: 180,
                  height: 180,
                ),
              ),
            );
          },
        ),

        // Bottom-left: Coral curves (floating left/right)
        AnimatedBuilder(
          animation: _controller3,
          builder: (context, child) {
            return Positioned(
              bottom: 80,
              left: 60 + (_controller3.value * 15),
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/shapes/shape_coral_curves.png',
                  width: 200,
                  height: 200,
                ),
              ),
            );
          },
        ),

        // Bottom-right: Yellow curves (rotating slowly)
        AnimatedBuilder(
          animation: _controller4,
          builder: (context, child) {
            return Positioned(
              bottom: 60,
              right: 80,
              child: Transform.rotate(
                angle: -_controller4.value * 0.15,
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

        // Center: Coral semicircle (floating up/down) - positioned in center area
        AnimatedBuilder(
          animation: _controller5,
          builder: (context, child) {
            return Positioned(
              top: size.height * 0.4 + (_controller5.value * 15),
              left: size.width * 0.25,
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/shapes/shape_coral_semicircle.png',
                  width: 220,
                  height: 220,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
