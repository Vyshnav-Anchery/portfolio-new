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
    this.maxTiltAngle = 0.06,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> with SingleTickerProviderStateMixin {
  double _rotateX = 0;
  double _rotateY = 0;
  bool _isHovered = false;
  Offset _localMousePos = Offset.zero;

  void _onHover(PointerEvent event) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final cardSize = renderBox.size;
    if (!cardSize.width.isFinite ||
        !cardSize.height.isFinite ||
        cardSize.width <= 0 ||
        cardSize.height <= 0) {
      return;
    }

    final x = event.localPosition.dx.clamp(0.0, cardSize.width);
    final y = event.localPosition.dy.clamp(0.0, cardSize.height);
    final centerX = cardSize.width / 2;
    final centerY = cardSize.height / 2;

    final percentX = ((x - centerX) / centerX).clamp(-1.0, 1.0);
    final percentY = ((y - centerY) / centerY).clamp(-1.0, 1.0);

    if (percentX.isNaN || percentY.isNaN) return;

    final newRotateX = (-percentY * widget.maxTiltAngle).clamp(
      -widget.maxTiltAngle,
      widget.maxTiltAngle,
    );
    final newRotateY = (percentX * widget.maxTiltAngle).clamp(
      -widget.maxTiltAngle,
      widget.maxTiltAngle,
    );

    if (newRotateX.isNaN || newRotateY.isNaN) return;

    setState(() {
      _rotateX = newRotateX;
      _rotateY = newRotateY;
      _localMousePos = Offset(x, y);
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

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: _isHovered ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          builder: (context, animVal, _) {
            final scaleVal = 1.0 + (0.015 * animVal);

            return Transform(
              alignment: Alignment.center,
              transformHitTests: false,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008) // safe perspective depth
                ..rotateX(_rotateX)
                ..rotateY(_rotateY)
                ..scaleByDouble(scaleVal, scaleVal, 1.0, 1.0),
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.cardBg,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: activeBorderColor, width: _isHovered ? 1.5 : 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: (widget.hoverBorderColor ?? AppColors.cyan).withValues(alpha: 0.15),
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
                              glowColor: widget.hoverBorderColor ?? AppColors.cyan,
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
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset mousePos;
  final Color glowColor;

  _SpotlightPainter({required this.mousePos, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (!size.width.isFinite || !size.height.isFinite || size.width <= 0 || size.height <= 0) {
      return;
    }

    final normX = ((mousePos.dx / size.width) * 2 - 1).clamp(-1.0, 1.0);
    final normY = ((mousePos.dy / size.height) * 2 - 1).clamp(-1.0, 1.0);

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(normX, normY),
        radius: 0.85,
        colors: [glowColor.withValues(alpha: 0.10), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.mousePos != mousePos || oldDelegate.glowColor != glowColor;
  }
}
