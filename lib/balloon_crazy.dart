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

  /// bankPenalty (BP) used by the original game's dynamic threshold (7 - BP)
  /// Default 0 for compatibility.
  int bankPenalty = 0;

  static const int _baseSP = 4;
  double currentSP = baseSP;
  double get width => size.x;
  double get height => size.y;
  double? lastWorldX;
  double? lastWidgetX;
  double widgetRenderWidth = 0.0;
  double widgetRenderHeight = 0.0;

  late PlayState _playState = PlayState.welcome;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
        overlays.add(playState.name);
        // hide floor and player on welcome
        playArea.floor.visible = false;
        playArea.player.opacity = 0;
        break;
      case PlayState.gameOver:
        overlays.add(playState.name);
        // hide world during game over
        playArea.floor.visible = false;
        playArea.player.opacity = 0;
        break;
      case PlayState.won:
        overlays.add(playState.name);
        // On win, keep the player visible (don't hide) and show floor so
        // the final state feels anchored; clear held balloons to avoid
        // leftover visuals.
        playArea.floor.visible = true;
        playArea.player.opacity = 1;
        playArea.player.reset();
        break;
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        // show floor/player when the game is playing
        playArea.floor.visible = true;
        playArea.player.opacity = 1;
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

    // Debug HUD removed per user request

    playState = PlayState.welcome;

    debugMode = false;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Balloon>());

    playArea.resetGame();
    score.value = 0;
    lives.value = initialLives;
    playState = PlayState.playing;
    final rows = gridRows;
    final columns = gridColumns;

    final balloonSize = Vector2(balloonWidth, balloonHeight);
    final spacingX = horizontalSpacing;
    final spacingY = verticalSpacing;

    final totalGridWidth = columns * (balloonSize.x + spacingX) - spacingX;
    final startX = ((gameWidth - totalGridWidth) / 2) + gridStartMargin;
    final startY = gridStartY + gridStartYOffset;

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
        balloon.velocity = Vector2(0, balloonDropSpeed);
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
        final matrixEmpty = balloonMatrix.every(
          (column) => column.every((balloon) => balloon == null),
        );
        // Consider the game finished only when the matrix is empty and there
        // are no balloons still falling (velocity.y > 0). Some balloon
        // components may remain with zero velocity (stalled); those should
        // not block the win condition.
        final anyFalling = world.children.whereType<Balloon>().any(
          (balloon) => balloon.velocity.y > 0,
        );
        if (matrixEmpty && !anyFalling) {
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

  /// Increase the current SP by [delta]. This affects how strictly we check
  /// vertical collision windows and/or speeds. Keep simple for now.
  void increaseSP(double delta) {
    currentSP += delta;
  }

  /// Reset SP (speed/precision state) back to the documented base value.
  void resetSPtoBase() {
    currentSP = baseSP;
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
      // store widget-x for diagnostics
      final widgetX = info.eventPosition.widget.x;
      lastWidgetX = widgetX;

      // If we know the rendered GameWidget width, compute a proportional
      // mapping from widget X -> world X so touches map across the full
      // gameWidth regardless of layout scaling (FittedBox, etc.).
      double worldX;
      if (widgetRenderWidth > 0) {
        final ratio = (widgetX / widgetRenderWidth).clamp(0.0, 1.0);
        worldX = ratio * gameWidth;
      } else {
        // Fallback to camera mapping if render size isn't available yet.
        final worldPos = camera.viewfinder.globalToLocal(
          info.eventPosition.global,
        );
        worldX = worldPos.x;
      }

      lastWorldX = worldX;

      // Immediate movement: set player position directly to follow finger
      final minX = player.size.x / 2;
      final maxX = gameWidth - player.size.x / 2;
      final newX = worldX.clamp(minX, maxX);
      player.targetX = newX;
      player.position.x = newX;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (playState == PlayState.playing) {
      final widgetX = info.eventPosition.widget.x;
      lastWidgetX = widgetX;

      double worldX;
      if (widgetRenderWidth > 0) {
        final ratio = (widgetX / widgetRenderWidth).clamp(0.0, 1.0);
        worldX = ratio * gameWidth;
      } else {
        final worldPos = camera.viewfinder.globalToLocal(
          info.eventPosition.global,
        );
        worldX = worldPos.x;
      }

      lastWorldX = worldX;
      // immediate set to test movement responsiveness
      player.targetX = worldX;
      player.position.x = worldX;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (playState == PlayState.playing) {
      final widgetX = info.eventPosition.widget.x;
      lastWidgetX = widgetX;

      double worldX;
      if (widgetRenderWidth > 0) {
        final ratio = (widgetX / widgetRenderWidth).clamp(0.0, 1.0);
        worldX = ratio * gameWidth;
      } else {
        final worldPos = camera.viewfinder.globalToLocal(
          info.eventPosition.global,
        );
        worldX = worldPos.x;
      }

      lastWorldX = worldX;
      // immediate set when tapping
      player.targetX = worldX;
      player.position.x = worldX;
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
