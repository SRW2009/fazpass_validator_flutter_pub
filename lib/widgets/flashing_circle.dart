
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FlashingCircle extends StatefulWidget {
  const FlashingCircle({
    super.key,
    required this.flashColor,
    required this.borderWidth,
  });

  final Color flashColor;
  final double borderWidth;

  @override
  State<FlashingCircle> createState() => _FlashingCircleState();
}

class _FlashingCircleState extends State<FlashingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..repeat(reverse: true, period: const Duration(seconds: 1));
    _animation = ColorTween(begin: Colors.white, end: widget.flashColor).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: GradientBoxBorder(
              gradient: RadialGradient(colors: [
                widget.flashColor,
                _animation.value!,
                Theme.of(context).scaffoldBackgroundColor,
              ]),
              width: widget.borderWidth,
            ),
          ),
        );
      },
    );
  }
}
