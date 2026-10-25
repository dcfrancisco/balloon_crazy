import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:balloon_crazy/features/adventure/domain/level_catalog.dart';
import 'package:balloon_crazy/features/adventure/domain/level_definition.dart';

enum V2LevelOnePhase { briefing, playing, results }

enum V2LevelOneOutcome { won, lost }

/// Small, deterministic controller for the first V2 playable slice.
///
/// It deliberately has no Flame dependency so the briefing, board, objective,
/// and results flow can be tested without a device renderer.
class V2LevelOneController extends ChangeNotifier {
  V2LevelOneController({V2LevelDefinition? level})
    : level = level ?? v2Levels.first,
      lives = (level ?? v2Levels.first).startingLives,
      _balloonXs = _makeBalloonXs(
        (level ?? v2Levels.first).tuning.totalSpawnCount,
        (level ?? v2Levels.first).seed,
      ) {
    assert(this.level.number == 1);
  }

  final V2LevelDefinition level;
  final List<double> _balloonXs;

  V2LevelOnePhase phase = V2LevelOnePhase.briefing;
  V2LevelOneOutcome? outcome;
  double playerX = 0.5;
  double balloonY = 0;
  int balloonIndex = 0;
  int catches = 0;
  int misses = 0;
  int lives;
  int score = 0;
  int held = 0;
  int banked = 0;

  static const double catchPlane = 0.78;
  static const double missPlane = 0.98;
  static const double catchDistance = 0.11;

  double get balloonX => _balloonXs[balloonIndex];
  int get target => level.primaryObjective.target;
  double get objectiveProgress => min(1, catches / target);
  bool get isWon => outcome == V2LevelOneOutcome.won;

  void begin() {
    if (phase != V2LevelOnePhase.briefing) return;
    phase = V2LevelOnePhase.playing;
    _resetBalloon();
    notifyListeners();
  }

  void movePlayer(double normalizedX) {
    playerX = normalizedX.clamp(0.08, 0.92);
    notifyListeners();
  }

  void tick(double dt) {
    if (phase != V2LevelOnePhase.playing) return;
    balloonY += level.tuning.startSpeed / 1600 * dt;
    if (balloonY >= catchPlane && (balloonX - playerX).abs() <= catchDistance) {
      _catchBalloon();
    } else if (balloonY >= missPlane) {
      _missBalloon();
    } else {
      notifyListeners();
    }
  }

  void restart() {
    phase = V2LevelOnePhase.briefing;
    outcome = null;
    playerX = 0.5;
    balloonIndex = 0;
    catches = 0;
    misses = 0;
    lives = level.startingLives;
    score = 0;
    held = 0;
    banked = 0;
    balloonY = 0;
    notifyListeners();
  }

  void _catchBalloon() {
    catches++;
    score += 10;
    held++;
    if (held == 4) {
      banked += held;
      held = 0;
    }
    if (catches >= target) {
      outcome = V2LevelOneOutcome.won;
      phase = V2LevelOnePhase.results;
    } else {
      _advanceBalloon();
    }
    notifyListeners();
  }

  void _missBalloon() {
    misses++;
    lives = max(0, lives - 1);
    held = 0;
    if (lives == 0 || balloonIndex == _balloonXs.length - 1) {
      outcome = V2LevelOneOutcome.lost;
      phase = V2LevelOnePhase.results;
    } else {
      _advanceBalloon();
    }
    notifyListeners();
  }

  void _advanceBalloon() {
    balloonIndex++;
    _resetBalloon();
  }

  void _resetBalloon() {
    balloonY = 0;
  }

  static List<double> _makeBalloonXs(int count, int seed) {
    final random = Random(seed);
    return List<double>.generate(
      count,
      (_) => 0.16 + random.nextDouble() * 0.68,
      growable: false,
    );
  }
}
