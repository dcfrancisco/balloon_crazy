import 'dart:async';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:balloon_crazy/components/components.dart';
import 'package:balloon_crazy/config.dart';
import 'package:balloon_crazy/domain/game_session.dart';
import 'package:balloon_crazy/domain/swept_collision.dart';
import 'package:balloon_crazy/input/game_coordinate_mapper.dart';

enum PlayState { welcome, playing, gameOver, won }

class BalloonCrazy extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  late final Player player;
  late PlayArea playArea;

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
  late GameSession session;

  /// bankPenalty (BP) used by the original game's dynamic threshold (7 - BP)
  /// Default 0 for compatibility.
  int bankPenalty = 0;

  double currentSP = baseSP;
  double get width => size.x;
  double get height => size.y;
  double? lastWorldX;
  double? lastWidgetX;
  double widgetRenderWidth = 0.0;
  double widgetRenderHeight = 0.0;
  final coordinateMapper = const GameCoordinateMapper(
    worldWidth: gameWidth,
    worldHeight: gameHeight,
  );

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
        // Keep the player visible during the game over overlay so the
        // final held balloons are shown. The floor remains hidden to
        // emphasize the overlay.
        playArea.floor.visible = false;
        playArea.player.opacity = 1;
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
    session = GameSession(seed: rand.nextInt(1 << 31));
    spawnNextBalloon();
  }

  void spawnNextBalloon() {
    session.startNext();
    final selected = session.activeBalloon;
    if (selected == null) {
      final events = session.finishBoard();
      for (final event in events) {
        if (event is BankSettled) {
          score.value += event.points;
          player.clearHeldVisuals();
        }
      }
      if (events.whereType<SessionFinished>().isNotEmpty) {
        playState = PlayState.won;
      }
      return;
    }
    world.add(
      Balloon(
        position: Vector2(selected.x * gameWidth, 40),
        size: Vector2(balloonWidth, balloonHeight),
        velocity: Vector2(0, GameSession.baseSpeed),
        domainId: selected.id,
        rowIndex: selected.row,
        columnIndex: selected.column,
      ),
    );
  }

  void onBalloonCaught(Balloon balloon) {
    if (session.activeBalloon?.id != balloon.domainId) return;
    final events = session.catchActive();
    for (final event in events) {
      if (event is BankSettled) {
        score.value += event.points;
        player.clearHeldVisuals();
      }
    }
    if (session.activeBalloon == null && session.phase == SessionPhase.playing) {
      spawnNextBalloon();
    }
  }

  bool balloonCrossedPlayer(
    Balloon balloon, {
    required double previousY,
    required double nextY,
  }) {
    return sweptVerticalCatch(
      previousY: previousY,
      nextY: nextY,
      objectHeight: balloon.size.y,
      objectX: balloon.position.x,
      objectWidth: balloon.size.x,
      targetY: player.position.y,
      targetHeight: player.size.y,
      targetX: player.position.x,
      targetWidth: player.size.x,
    );
  }

  bool balloonCrossedFloor(
    Balloon balloon, {
    required double previousY,
    required double nextY,
  }) {
    return sweptVerticalCatch(
      previousY: previousY,
      nextY: nextY,
      objectHeight: balloon.size.y,
      objectX: balloon.position.x,
      objectWidth: balloon.size.x,
      targetY: playArea.floor.position.y + playArea.floor.size.y / 2,
      targetHeight: playArea.floor.size.y,
      targetX: playArea.floor.position.x + playArea.floor.size.x / 2,
      targetWidth: playArea.floor.size.x,
    );
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
      _movePlayerToWidgetPoint(
        info.eventPosition.widget.x,
        info.eventPosition.widget.y,
      );
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (playState == PlayState.playing) {
      _movePlayerToWidgetPoint(
        info.eventPosition.widget.x,
        info.eventPosition.widget.y,
      );
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (playState == PlayState.playing) {
      _movePlayerToWidgetPoint(
        info.eventPosition.widget.x,
        info.eventPosition.widget.y,
      );
    }
  }

  void _movePlayerToWidgetPoint(double widgetX, double widgetY) {
    lastWidgetX = widgetX;
    final worldPoint = coordinateMapper.worldPoint(
      widgetX: widgetX,
      widgetY: widgetY,
      renderWidth: widgetRenderWidth,
      renderHeight: widgetRenderHeight,
    );
    final minX = player.size.x / 2;
    final maxX = gameWidth - player.size.x / 2;
    final worldX = worldPoint.x.clamp(minX, maxX);
    lastWorldX = worldX;
    player.targetX = worldX;
    player.position.x = worldX;
  }

  void onBalloonMissed(Balloon balloon) {
    if (session.activeBalloon?.id != balloon.domainId) return;
    session.missActive();
    lives.value = session.lives;
    if (session.phase == SessionPhase.gameOver) {
      playState = PlayState.gameOver;
    } else {
      player.reset();
      spawnNextBalloon();
    }
  }

  @override
  Color backgroundColor() => const Color(0xff5555fa);
}
