import 'dart:async';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:balloon_crazy/components/components.dart';
import 'package:balloon_crazy/config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BalloonCrazy extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  List<List<Balloon>> columnsBalloons = [];

  BalloonCrazy()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState = PlayState.welcome;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
        break;
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    playState = PlayState.welcome;

    debugMode = false;
  }

  void startGame() {
    if (playState == PlayState.playing) return;
    world.removeAll(world.children.query<Balloon>());

    score.value = 0;
    playState = PlayState.playing;

    final playArea = PlayArea();
    world.add(playArea);

    const rows = 4;
    const columns = 10;

    final balloonSize = Vector2(55, 55);
    const spacingX = 20.0;
    const spacingY = 20.0;

    final totalGridWidth = columns * (balloonSize.x + spacingX) - spacingX;

    final startX = ((gameWidth - totalGridWidth) / 2) + 20;
    const startY = 100;

    columnsBalloons = List.generate(columns, (_) => []);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final balloon = Balloon(
          position: Vector2(
            startX + col * (balloonSize.x + spacingX),
            startY + row * (balloonSize.y + spacingY),
          ),
          size: balloonSize,
          velocity: Vector2(0, 0),
        );
        world.add(balloon);

        columnsBalloons[col].add(balloon);
      }

      const floorHeight = 150.0;
      final floorPositionY = size.y - floorHeight;

      final floor = Floor(
        position: Vector2(0, floorPositionY),
        size: Vector2(size.x, floorHeight),
      );
      world.add(floor);

      // startDroppingBalloons();
    }
  }

  void dropBalloon() {
    final random = math.Random();
    final columnIndex = random.nextInt(columnsBalloons.length);

    if (columnsBalloons.isNotEmpty) {
      final balloon = columnsBalloons[columnIndex].removeLast();

      balloon.velocity = Vector2(0, -100);
    }
  }

  void startDroppingBalloons() {
    final random = math.Random();

    void dropBalloonAtRandomInterval() {
      final interval = random.nextInt(10) + 1;
      Timer(Duration(seconds: interval) as double, onTick: () {
        dropBalloon();
        if (columnsBalloons.isNotEmpty) {
          dropBalloonAtRandomInterval();
        }
      });
    }

    dropBalloonAtRandomInterval();
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  Color backgroundColor() => const Color(0xff5555fa);
}
