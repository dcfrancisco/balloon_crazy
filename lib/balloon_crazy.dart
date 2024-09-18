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
  List<List<Balloon?>> balloonMatrix = [];
  late TimerComponent balloonDropTimer;

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

    balloonMatrix = List.generate(
      columns,
      (col) => List<Balloon?>.filled(rows, null),
    );

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

        balloonMatrix[col][row] = balloon;
      }

      const floorHeight = 200.0;
      final floorPositionY = size.y - floorHeight;

      final floor = Floor(
        position: Vector2(0, floorPositionY),
        size: Vector2(size.x, floorHeight),
      );
      world.add(floor);

      startDroppingBalloons();
    }
  }

  void dropBalloon() {
    final random = math.Random();
    final columnIndex = random.nextInt(balloonMatrix.length);

    for (int row = balloonMatrix[columnIndex].length - 1; row >= 0; row--) {
      final balloon = balloonMatrix[columnIndex][row];
      if (balloon != null && balloon.velocity == Vector2.zero()) {
        balloon.velocity = Vector2(0, 100);
        balloonMatrix[columnIndex][row] = null;
        break;
      }
    }
  }

  void startDroppingBalloons() {
    if (playState != PlayState.playing) return;

    final randomInterval = rand.nextDouble() * 10 + 1;
    balloonDropTimer = TimerComponent(
      period: randomInterval,
      repeat: true,
      onTick: () {
        dropBalloon();
        if (balloonMatrix
            .every((column) => column.every((balloon) => balloon == null))) {
          balloonDropTimer.removeFromParent();
          playState = PlayState.won;
        }
      },
    );
    add(balloonDropTimer);
  }

  @override
  void onTap() {
    super.onTap();
    if (playState != PlayState.playing) {
      startGame();
    }
  }

  @override
  Color backgroundColor() => const Color(0xff5555fa);
}
