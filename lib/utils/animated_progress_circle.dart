import 'package:flutter/material.dart';

class AnimatedProgressCircle extends StatefulWidget {
  final double percentage; // value between 0 and 100
  final Color colour;

  const AnimatedProgressCircle({super.key, required this.percentage, required this.colour});

  @override
  State<AnimatedProgressCircle> createState() => _AnimatedProgressCircleState();
}

class _AnimatedProgressCircleState extends State<AnimatedProgressCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: widget.percentage / 100).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(begin: _animation.value, end: widget.percentage / 100).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 35,
          height: 35,
          child: CircularProgressIndicator(
            value: _animation.value,
            strokeWidth: 3,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(widget.colour),
          ),
        ),
        Text(
          "${(_animation.value * 100).toInt()}%",
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
