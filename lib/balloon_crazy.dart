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

  // Row-based balloon system (like original BP=0 to BP=3)
  List<List<Balloon>> balloonRows = [];
  int currentRow = 3; // Start from top row (BP=3 in original)
  Balloon? fallingBalloon;
  double balloonSpeed = 100.0; // Base speed (SP! in original)
  final double baseSpeed = 100.0;

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
    player = playArea.player;

    playState = PlayState.welcome;

    debugMode = false;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    playArea.resetGame();
    score.value = 0;
    lives.value = 4;
    currentRow = 3;
    balloonSpeed = baseSpeed;
    fallingBalloon = null;
    playState = PlayState.playing;

    const rows = 4;
    const columns = 15; // Original has 15 balloons per row

    final balloonSize = Vector2(45, 45);
    const spacingX = 15.0;
    const spacingY = 20.0;

    final totalGridWidth = columns * (balloonSize.x + spacingX) - spacingX;
    final startX = ((gameWidth - totalGridWidth) / 2);
    const startY = 80.0;

    // Create 4 rows of balloons (top to bottom = rows 3,2,1,0)
    balloonRows = List.generate(rows, (rowIndex) {
      List<Balloon> row = [];
      for (int col = 0; col < columns; col++) {
        final balloon = Balloon(
          position: Vector2(
            startX + col * (balloonSize.x + spacingX),
            startY + (3 - rowIndex) * (balloonSize.y + spacingY),
          ),
          size: balloonSize,
          velocity: Vector2(0, 0),
          rowIndex: rowIndex,
          columnIndex: col,
        );
        world.add(balloon);
        row.add(balloon);
      }
      return row;
    });

    startDroppingBalloons();
  }

  void dropBalloon() {
    // If a balloon is already falling, don't drop another (one at a time!)
    if (fallingBalloon != null && !fallingBalloon!.isMounted) {
      fallingBalloon = null;
    }
    if (fallingBalloon != null) return;

    // Find current active row
    while (currentRow >= 0 && balloonRows[currentRow].isEmpty) {
      currentRow--; // Move to next row (BP = BP - 1 in original)
    }

    // Check if all balloons are gone (win condition)
    if (currentRow < 0) {
      balloonDropTimer.removeFromParent();
      playState = PlayState.won;
      return;
    }

    // Pick random balloon from current row
    final availableBalloons = balloonRows[currentRow];
    if (availableBalloons.isEmpty) return;

    final randomIndex = rand.nextInt(availableBalloons.length);
    final balloon = availableBalloons[randomIndex];

    // Remove from row list
    balloonRows[currentRow].removeAt(randomIndex);

    // Start balloon falling at current speed
    balloon.velocity = Vector2(0, balloonSpeed);
    fallingBalloon = balloon;
  }

  void startDroppingBalloons() {
    if (playState != PlayState.playing) return;

    // Drop balloons more frequently than original (for better mobile gameplay)
    balloonDropTimer = TimerComponent(
      period: 1.5,
      repeat: true,
      onTick: dropBalloon,
    );
    add(balloonDropTimer);
  }

  void onBalloonCaught(Balloon balloon) {
    if (balloon == fallingBalloon) {
      fallingBalloon = null;
    }

    // Increase speed with each catch (SP! = SP! + 0.5 in original)
    balloonSpeed += 12.5; // Scaled for our speed units
  }

  void resetBalloonSpeed() {
    // Reset speed on banking (SP! = 4 in original)
    balloonSpeed = baseSpeed;
  }

  int getBalloonsNeededForBanking() {
    // Dynamic banking: 7 - BP (row number)
    // Row 3: need 4, Row 2: need 5, Row 1: need 6, Row 0: need 7
    return 7 - currentRow;
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
      player.targetX = info.eventPosition.global.x;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (playState == PlayState.playing) {
      player.targetX = info.eventPosition.global.x;
    }
  }

  void onLoseLife() {
    // Pop all held balloons when losing a life
    player.popAllBalloons();

    lives.value--;
    if (lives.value <= 0) {
      playState = PlayState.gameOver;
    } else {
      // Reset for next life
      player.reset();
      balloonSpeed = baseSpeed;
      fallingBalloon = null;
    }
  }

  @override
  Color backgroundColor() => const Color(0xff5555fa);
}
