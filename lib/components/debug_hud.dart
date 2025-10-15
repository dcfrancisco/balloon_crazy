import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';

class DebugHud extends TextComponent with HasGameReference<BalloonCrazy> {
  DebugHud()
    : super(
        text: '',
        position: Vector2(8, 8),
        anchor: Anchor.topLeft,
        priority: 1000,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.2,
          ),
        ),
      );

  @override
  void update(double dt) {
    super.update(dt);
    final p = game.player;
    final state = game.playState;
    final playerX = p.position.x.toStringAsFixed(1);
    final targetX = p.targetX.toStringAsFixed(1);
    final worldX = (game.lastWorldX != null)
        ? game.lastWorldX!.toStringAsFixed(1)
        : 'null';
    final widgetX = (game.lastWidgetX != null)
        ? game.lastWidgetX!.toStringAsFixed(1)
        : 'null';
    text =
        'state: $state\nplayerX: $playerX\ntargetX: $targetX\nworldX: $worldX\nwidgetX: $widgetX';
  }
}
