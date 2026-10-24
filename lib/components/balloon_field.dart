import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import 'package:balloon_crazy/config.dart';

/// The visible, non-interactive board of balloons.
///
/// The rules engine still owns the one active falling balloon. These sprites
/// are only the remaining board presentation and never participate in
/// collision or scoring.
class BalloonField extends PositionComponent {
  BalloonField() : super(size: Vector2(gameWidth, gameHeight));

  final Map<String, SpriteComponent> _balloons = {};
  late Sprite _sprite;
  bool _ready = false;
  bool visible = true;

  @override
  void render(Canvas canvas) {
    if (!visible) return;
    super.render(canvas);
  }

  @override
  FutureOr<void> onLoad() async {
    _sprite = await Sprite.load('red_balloon.png');
    _ready = true;
    _populate();
  }

  void _populate() {
    final availableWidth =
        gameWidth -
        (2 * gridStartMargin) -
        (gridColumns - 1) * horizontalSpacing;
    final fieldBalloonSize = availableWidth / gridColumns;
    final balloonSize = Vector2(fieldBalloonSize, fieldBalloonSize);
    final startX = gridStartMargin;
    final startY = gridStartY + gridStartYOffset;

    for (var row = 0; row < gridRows; row++) {
      for (var column = 0; column < gridColumns; column++) {
        final component = SpriteComponent(
          sprite: _sprite,
          position: Vector2(
            startX + column * (balloonSize.x + horizontalSpacing),
            startY + row * (balloonSize.y + verticalSpacing),
          ),
          size: balloonSize,
        );
        _balloons[_key(row, column)] = component;
        add(component);
      }
    }
  }

  void reset() {
    if (!_ready) return;
    for (final balloon in _balloons.values) {
      balloon.removeFromParent();
    }
    _balloons.clear();
    for (final child in children.toList()) {
      child.removeFromParent();
    }
    _populate();
  }

  void removeBalloon({required int row, required int column}) {
    _balloons.remove(_key(row, column))?.removeFromParent();
  }

  static String _key(int row, int column) => '$row:$column';
}
