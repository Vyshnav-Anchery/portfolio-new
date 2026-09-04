import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// 3D perspective tilt card that responds smoothly to pointer hover,
/// casting a dynamic radial specular shine following the mouse cursor.
class TiltCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double maxTiltAngle; // In radians

  const TiltCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.borderColor,
    this.hoverBorderColor,
    this.backgroundColor,
    this.padding,
    this.maxTiltAngle = 0.08,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard>
    with SingleTickerProviderStateMixin {
  double _rotateX = 0;
  double _rotateY = 0;
  bool _isHovered = false;
  Offset _localMousePos = Offset.zero;

  void _onHover(PointerEvent event, Size size) {
    final x = event.localPosition.dx;
    final y = event.localPosition.dy;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Normalize between -1.0 and 1.0
    final percentX = (x - centerX) / centerX;
    final percentY = (y - centerY) / centerY;

    setState(() {
      _rotateX = -percentY * widget.maxTiltAngle;
      _rotateY = percentX * widget.maxTiltAngle;
      _localMousePos = event.localPosition;
    });
  }

  void _onEnter(PointerEvent event) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _rotateX = 0;
      _rotateY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeBorderColor = _isHovered
        ? (widget.hoverBorderColor ?? AppColors.cyan)
        : (widget.borderColor ?? AppColors.cardBorder);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return MouseRegion(
          cursor: widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: _onEnter,
          onExit: _onExit,
          onHover: (e) => _onHover(e, size),
          child: GestureDetector(
            onTap: widget.onTap,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _isHovered ? 1.0 : 0.0,
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              builder: (context, animVal, _) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective depth
                    ..rotateX(_rotateX)
                    ..rotateY(_rotateY)
                    ..scaleByDouble(
                      1.0 + (0.015 * animVal),
                      1.0 + (0.015 * animVal),
                      1.0,
                      1.0,
                    ),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? AppColors.cardBg,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: activeBorderColor,
                        width: _isHovered ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        if (_isHovered)
                          BoxShadow(
                            color: (widget.hoverBorderColor ?? AppColors.cyan)
                                .withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Dynamic mouse spotlight glow
                        if (_isHovered)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: _SpotlightPainter(
                                  mousePos: _localMousePos,
                                  glowColor: widget.hoverBorderColor ??
                                      AppColors.cyan,
                                ),
                              ),
                            ),
                          ),
                        widget.child,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset mousePos;
  final Color glowColor;

  _SpotlightPainter({required this.mousePos, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (mousePos.dx / size.width) * 2 - 1,
          (mousePos.dy / size.height) * 2 - 1,
        ),
        radius: 0.85,
        colors: [
          glowColor.withValues(alpha: 0.10),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.mousePos != mousePos ||
        oldDelegate.glowColor != glowColor;
  }
}
