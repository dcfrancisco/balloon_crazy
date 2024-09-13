import 'dart:async';
import 'dart:math' as math;

import 'package:balloon_crazy/components/play_area.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/components.dart';
import 'config.dart';

class BalloonCrazy extends FlameGame {
  BalloonCrazy()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final rand = math.Random();

  double get width => size.x;
  double get height => size.y;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    const balloonCount = 10;

    for (var i = 0; i < balloonCount; i++) {
      final balloon = Balloon(
        velocity: Vector2(
          rand.nextDouble() * 100 - 50,
          rand.nextDouble() * 100 - 50,
        ),
        position: Vector2(
          rand.nextDouble() * width,
          rand.nextDouble() * height,
        ),
        radius: 20 + rand.nextDouble() * 40,
      );

      world.add(balloon);
    }
  }
}
