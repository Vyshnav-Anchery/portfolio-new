import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final String prefix;
  final String suffix;
  final TextStyle style;
  final Duration duration;
  final bool formatWithCommas;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.prefix = '',
    this.suffix = '',
    required this.style,
    this.duration = const Duration(milliseconds: 2000),
    this.formatWithCommas = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    if (!widget.formatWithCommas) return number.toString();
    final str = number.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentVal = (_animation.value * widget.targetValue).toInt();
        return Text(
          '${widget.prefix}${_formatNumber(currentVal)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
