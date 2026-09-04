import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Interactive constellation & particle mesh background with subtle floating drift
/// and pointer interaction.
class ParticleBackground extends StatefulWidget {
  final Widget child;

  const ParticleBackground({super.key, required this.child});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();
  Offset _pointerPos = const Offset(-1000, -1000);

  @override
  void initState() {
    super.initState();
    // Initialize 45 particles with random initial coordinates and speeds
    for (int i = 0; i < 45; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          vx: (_random.nextDouble() - 0.5) * 0.0007,
          vy: (_random.nextDouble() - 0.5) * 0.0007,
          radius: _random.nextDouble() * 2.2 + 1.2,
          alpha: _random.nextDouble() * 0.5 + 0.2,
          color: i % 3 == 0
              ? AppColors.cyan
              : (i % 3 == 1 ? AppColors.purple : AppColors.blue),
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _pointerPos = event.localPosition;
        });
      },
      child: Stack(
        children: [
          // Deep ambient dark background with glowing mesh spots
          Positioned.fill(
            child: Container(
              color: AppColors.background,
            ),
          ),
          // Ambient soft radial gradient 1 (Top Left Cyan)
          Positioned(
            top: -150,
            left: -100,
            width: 700,
            height: 700,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ambient soft radial gradient 2 (Middle Right Purple)
          Positioned(
            top: 400,
            right: -150,
            width: 800,
            height: 800,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.purple.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ambient soft radial gradient 3 (Bottom Left Emerald)
          Positioned(
            bottom: 200,
            left: -100,
            width: 600,
            height: 600,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.emerald.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Animated Particle Canvas
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // Update particle positions
                for (final p in _particles) {
                  p.x += p.vx;
                  p.y += p.vy;

                  if (p.x < 0) p.x = 1.0;
                  if (p.x > 1) p.x = 0.0;
                  if (p.y < 0) p.y = 1.0;
                  if (p.y > 1) p.y = 0.0;
                }

                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    pointerPos: _pointerPos,
                  ),
                );
              },
            ),
          ),
          // The page content
          widget.child,
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double alpha;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.alpha,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset pointerPos;

  _ParticlePainter({required this.particles, required this.pointerPos});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..strokeWidth = 0.8;
    final dotPaint = Paint()..style = PaintingStyle.fill;

    final double maxDist = 130.0;

    // Draw connecting lines
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      final pos1 = Offset(p1.x * size.width, p1.y * size.height);

      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final pos2 = Offset(p2.x * size.width, p2.y * size.height);

        final dist = (pos1 - pos2).distance;
        if (dist < maxDist) {
          final opacity = (1.0 - (dist / maxDist)) * 0.22;
          linePaint.color = p1.color.withValues(alpha: opacity);
          canvas.drawLine(pos1, pos2, linePaint);
        }
      }

      // Proximity line to mouse cursor
      final mouseDist = (pos1 - pointerPos).distance;
      if (mouseDist < 160.0) {
        final opacity = (1.0 - (mouseDist / 160.0)) * 0.45;
        linePaint.color = AppColors.cyan.withValues(alpha: opacity);
        canvas.drawLine(pos1, pointerPos, linePaint);
      }

      // Draw particle dot
      dotPaint.color = p1.color.withValues(alpha: p1.alpha);
      canvas.drawCircle(pos1, p1.radius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
