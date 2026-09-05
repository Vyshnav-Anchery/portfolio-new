import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Wraps a widget with an animated continuous sweep gradient border
/// (Aceternity/Linear style rotating neon perimeter).
class GlowBorderCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Duration duration;
  final List<Color>? glowColors;

  const GlowBorderCard({
    super.key,
    required this.child,
    this.borderRadius = 42,
    this.borderWidth = 2.0,
    this.duration = const Duration(seconds: 6),
    this.glowColors,
  });

  @override
  State<GlowBorderCard> createState() => _GlowBorderCardState();
}

class _GlowBorderCardState extends State<GlowBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConicBorderPainter(
            angle: _controller.value * 2 * math.pi,
            borderRadius: widget.borderRadius,
            borderWidth: widget.borderWidth,
            colors: widget.glowColors ??
                const [
                  AppColors.cyan,
                  AppColors.purple,
                  Colors.transparent,
                  AppColors.cyan,
                ],
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.borderWidth),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _ConicBorderPainter extends CustomPainter {
  final double angle;
  final double borderRadius;
  final double borderWidth;
  final List<Color> colors;

  _ConicBorderPainter({
    required this.angle,
    required this.borderRadius,
    required this.borderWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!size.width.isFinite || !size.height.isFinite || size.width <= 0 || size.height <= 0) {
      return;
    }

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(angle),
        colors: colors,
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _ConicBorderPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
