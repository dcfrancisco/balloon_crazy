import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/domain/game_session.dart';

void main() {
  test('catches do not score until the source-row bank threshold', () {
    final session = GameSession(seed: 7);
    final caught = <GameEvent>[];
    for (var i = 0; i < 3; i++) {
      session.startNext();
      caught.addAll(session.catchActive());
    }

    expect(caught.whereType<BalloonCaught>(), hasLength(3));
    expect(session.held, 3);
    expect(session.score, 0);

    session.startNext();
    final bankEvents = session.catchActive();
    expect(bankEvents.whereType<BankSettled>().single.points, 40);
    expect(session.score, 40);
    expect(session.held, 0);
  });

  test('a miss clears the held stack and consumes exactly one life', () {
    final session = GameSession(seed: 1);
    session.startNext();
    session.catchActive();
    session.startNext();

    final events = session.missActive();
    expect(events.whereType<BalloonMissed>().single.livesRemaining, 3);
    expect(session.held, 0);
    expect(session.score, 0);
    expect(session.speed, GameSession.baseSpeed);
  });

  test('same seed selects the same columns', () {
    final left = GameSession(seed: 99);
    final right = GameSession(seed: 99);
    final leftColumns = <int>[];
    final rightColumns = <int>[];
    for (var i = 0; i < 10; i++) {
      left.startNext();
      right.startNext();
      leftColumns.add(left.activeBalloon!.column);
      rightColumns.add(right.activeBalloon!.column);
      left.missActive();
      right.missActive();
    }
    expect(leftColumns, rightColumns);
  });

  test('terminal miss rejects future gameplay', () {
    final session = GameSession(seed: 4);
    for (var i = 0; i < 4; i++) {
      session.startNext();
      session.missActive();
    }
    expect(session.phase, SessionPhase.gameOver);
    expect(session.startNext(), isEmpty);
    expect(session.catchActive(), isEmpty);
  });
}
