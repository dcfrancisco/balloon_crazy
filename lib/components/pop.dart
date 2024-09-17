import 'package:flutter/material.dart';

class Pop extends StatefulWidget {
  @override
  _PopState createState() => _PopState();
}

class _PopState extends State<Pop> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat();

    _animation = IntTween(begin: 0, end: 2).animate(_controller);
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
      builder: (context, child) {
        return Image.asset(
          'assets/images/balloon_pop.png',
          fit: BoxFit.contain,
          gaplessPlayback: true,
          scale: _animation.value.toDouble() + 0.0,
        );
      },
    );
  }
}
