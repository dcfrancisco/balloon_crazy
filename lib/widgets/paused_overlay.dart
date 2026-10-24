import 'package:flutter/material.dart';

import 'package:balloon_crazy/balloon_crazy.dart';

class PausedOverlay extends StatelessWidget {
  const PausedOverlay({required this.game, super.key});

  final BalloonCrazy game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Center(
          child: Card(
            color: const Color(0xfff8f4e8),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('PAUSED', style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 16),
                  const Text('Your balloons are safe.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: game.resumeGame,
                    child: const Text('RESUME'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
