import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.score, this.lives});

  final ValueNotifier<int> score;
  final ValueListenable<int>? lives;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: score,
      builder: (context, scoreValue, child) {
        // Build the lives display: if a lives ValueListenable is provided
        // render it reactively; otherwise show four filled icons as a
        // placeholder.
        Widget livesWidget;
        if (lives != null) {
          livesWidget = ValueListenableBuilder<int>(
            valueListenable: lives!,
            builder: (context, liveCount, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (i) {
                  final filled = i < liveCount;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: filled ? 1.0 : 0.25,
                      curve: Curves.easeOut,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: filled ? 1.0 : 0.85,
                        curve: Curves.easeOutBack,
                        child: Image.asset(
                          'assets/images/player.png',
                          height: 12,
                          width: 12,
                          fit: BoxFit.contain,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          );
        } else {
          livesWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Image.asset(
                  'assets/images/player.png',
                  height: 12,
                  width: 12,
                  fit: BoxFit.contain,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  colorBlendMode: BlendMode.srcIn,
                ),
              );
            }),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              livesWidget,
              const SizedBox(width: 8),
              Text(
                'Score: $scoreValue'.toUpperCase(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 15.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
