import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Smooth floating ambient glow aura that trails the mouse cursor
/// across the web canvas with spring damping.
class CursorAuraFollower extends StatefulWidget {
  final Widget child;

  const CursorAuraFollower({super.key, required this.child});

  @override
  State<CursorAuraFollower> createState() => _CursorAuraFollowerState();
}

class _CursorAuraFollowerState extends State<CursorAuraFollower> {
  Offset _currentPos = const Offset(-200, -200);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _currentPos = event.position;
        });
      },
      child: Stack(
        children: [
          widget.child,

          // Glowing Aura Following Cursor with smooth implicit easing
          AnimatedPositioned(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            left: _currentPos.dx - 125,
            top: _currentPos.dy - 125,
            width: 250,
            height: 250,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.08),
                      AppColors.purple.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
