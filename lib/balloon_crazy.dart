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
    with HasCollisionDetection, TapDetector, PanDetector {
  late final Player player;
  late PlayArea playArea;

  // Column-based balloon system (simpler, works better)
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
  final ValueNotifier<int> lives = ValueNotifier<int>(4);
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

    playArea = PlayArea();
    world.add(playArea);

    // Wait for playArea to initialize
    await playArea.loaded;

    // Add player and floor directly to world (same level as balloons)
    player = playArea.player;
    world.add(player);
    world.add(playArea.floor);

    // Add debug HUD for on-device debugging
    final debugHud = DebugHud();
    world.add(debugHud);

    playState = PlayState.welcome;

    debugMode = false;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    // Remove any existing balloons
    world.removeAll(world.children.query<Balloon>());

    playArea.resetGame();
    score.value = 0;
    lives.value = 4;
    playState = PlayState.playing;

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
          rowIndex: row,
          columnIndex: col,
        );
        world.add(balloon);
        balloonMatrix[col][row] = balloon;
      }
    }

    startDroppingBalloons();
  }

  void dropBalloon() {
    final columnIndex = rand.nextInt(balloonMatrix.length);

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

    final randomInterval = rand.nextDouble() * 2 + 1;
    balloonDropTimer = TimerComponent(
      period: randomInterval,
      repeat: true,
      onTick: () {
        dropBalloon();
        if (balloonMatrix.every(
          (column) => column.every((balloon) => balloon == null),
        )) {
          balloonDropTimer.removeFromParent();
          playState = PlayState.won;
        }
      },
    );
    add(balloonDropTimer);
  }

  void onBalloonCaught(Balloon balloon) {
    // Remove balloon from matrix
    for (int col = 0; col < balloonMatrix.length; col++) {
      for (int row = 0; row < balloonMatrix[col].length; row++) {
        if (balloonMatrix[col][row] == balloon) {
          balloonMatrix[col][row] = null;
          break;
        }
      }
    }
  }

  @override
  void onTap() {
    super.onTap();
    if (playState != PlayState.playing) {
      startGame();
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (playState == PlayState.playing) {
      // Map screen/global coordinates to game world using the camera
      final worldPos = camera.viewfinder.globalToLocal(
        info.eventPosition.global,
      );
      player.targetX = worldPos.x;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (playState == PlayState.playing) {
      final worldPos = camera.viewfinder.globalToLocal(
        info.eventPosition.global,
      );
      player.targetX = worldPos.x;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (playState == PlayState.playing) {
      final worldPos = camera.viewfinder.globalToLocal(
        info.eventPosition.global,
      );
      player.targetX = worldPos.x;
    }
  }

  void onLoseLife() {
    lives.value--;
    if (lives.value <= 0) {
      playState = PlayState.gameOver;
      balloonDropTimer.removeFromParent();
    } else {
      player.reset();
    }
  }

  @override
  Color backgroundColor() => const Color(0xff5555fa);
}
