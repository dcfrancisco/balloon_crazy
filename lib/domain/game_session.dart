import 'dart:math';

/// The phases that are meaningful to the rules engine.
enum SessionPhase { playing, paused, gameOver, won }

/// A balloon selected by the deterministic board scheduler.
class ActiveBalloon {
  const ActiveBalloon({
    required this.id,
    required this.row,
    required this.column,
    required this.x,
    required this.y,
  });

  final int id;
  final int row;
  final int column;
  final double x;
  final double y;

  ActiveBalloon copyWith({double? y}) =>
      ActiveBalloon(id: id, row: row, column: column, x: x, y: y ?? this.y);
}

sealed class GameEvent {
  const GameEvent();
}

class BalloonCaught extends GameEvent {
  const BalloonCaught(this.balloon, this.heldCount);
  final ActiveBalloon balloon;
  final int heldCount;
}

class BankSettled extends GameEvent {
  const BankSettled(this.count, this.points);
  final int count;
  final int points;
}

class BalloonMissed extends GameEvent {
  const BalloonMissed(this.balloon, this.livesRemaining);
  final ActiveBalloon balloon;
  final int livesRemaining;
}

class SessionFinished extends GameEvent {
  const SessionFinished(this.outcome, this.score);
  final SessionPhase outcome;
  final int score;
}

/// Deterministic implementation of `docs/gameplay-rules-v1.md`.
///
/// The class deliberately has no Flutter or Flame dependency. Presentation
/// code consumes the events and projects [activeBalloon] and the counters.
class GameSession {
  GameSession({int seed = 0, this.rows = 4, this.columns = 15})
    : _random = Random(seed),
      currentRow = rows - 1,
      _remaining = List.generate(
        rows,
        (row) => <int>{for (var column = 0; column < columns; column++) column},
      );

  static const int startingLives = 4;
  static const double baseSpeed = 100;
  static const double catchPlane = 1200;
  static const double missPlane = 1450;
  static const double catchWindow = 72;

  final int rows;
  final int columns;
  final Random _random;
  final List<Set<int>> _remaining;

  SessionPhase phase = SessionPhase.playing;
  int score = 0;
  int lives = startingLives;
  int held = 0;
  int currentRow;
  double speed = baseSpeed;
  ActiveBalloon? activeBalloon;
  int _nextId = 0;

  int get resolved =>
      rows * columns -
      _remaining.fold<int>(0, (total, row) => total + row.length) -
      (activeBalloon == null ? 0 : 1);

  int get requiredToBank => 4 + (3 - currentRow);

  List<GameEvent> startNext() {
    if (phase != SessionPhase.playing || activeBalloon != null) return const [];
    while (currentRow >= 0 && _remaining[currentRow].isEmpty) {
      currentRow--;
    }
    if (currentRow < 0) {
      _finishIfReady();
      return const [];
    }
    final choices = _remaining[currentRow].toList()..sort();
    final column = choices[_random.nextInt(choices.length)];
    _remaining[currentRow].remove(column);
    activeBalloon = ActiveBalloon(
      id: _nextId++,
      row: currentRow,
      column: column,
      x: (column + 0.5) / columns,
      y: 0,
    );
    return const [];
  }

  List<GameEvent> tick(double dt, double playerX) {
    if (phase != SessionPhase.playing) return const [];
    startNext();
    final balloon = activeBalloon;
    if (balloon == null) return const [];
    final nextY = balloon.y + speed * dt;
    activeBalloon = balloon.copyWith(y: nextY);
    final events = <GameEvent>[];
    if (balloon.y < catchPlane &&
        nextY >= catchPlane &&
        (balloon.x * 1000 - playerX * 1000).abs() <= catchWindow) {
      events.addAll(catchActive());
    } else if (nextY >= missPlane) {
      events.addAll(missActive());
    }
    return events;
  }

  List<GameEvent> catchActive() {
    if (phase != SessionPhase.playing || activeBalloon == null) return const [];
    final caught = activeBalloon!;
    activeBalloon = null;
    held++;
    speed += 25;
    final events = <GameEvent>[BalloonCaught(caught, held)];
    if (held >= requiredToBank) events.addAll(bank());
    return events;
  }

  List<GameEvent> missActive() {
    if (phase != SessionPhase.playing || activeBalloon == null) return const [];
    final missed = activeBalloon!;
    activeBalloon = null;
    held = 0;
    speed = baseSpeed;
    lives = max(0, lives - 1);
    final events = <GameEvent>[BalloonMissed(missed, lives)];
    if (lives == 0) {
      phase = SessionPhase.gameOver;
      events.add(SessionFinished(phase, score));
    }
    return events;
  }

  List<GameEvent> bank() {
    if (held == 0 || phase != SessionPhase.playing) return const [];
    final count = held;
    final points = count * 10;
    held = 0;
    score += points;
    speed = baseSpeed;
    return <GameEvent>[BankSettled(count, points)];
  }

  void pause() {
    if (phase == SessionPhase.playing) phase = SessionPhase.paused;
  }

  void resume() {
    if (phase == SessionPhase.paused) phase = SessionPhase.playing;
  }

  List<GameEvent> finishBoard() {
    if (activeBalloon == null && held > 0) {
      final events = bank();
      _finishIfReady();
      if (phase == SessionPhase.won) events.add(SessionFinished(phase, score));
      return events;
    }
    _finishIfReady();
    if (phase == SessionPhase.won) {
      return <GameEvent>[SessionFinished(phase, score)];
    }
    return const [];
  }

  void _finishIfReady() {
    if (activeBalloon == null &&
        held == 0 &&
        _remaining.every((row) => row.isEmpty)) {
      phase = SessionPhase.won;
    }
  }
}
