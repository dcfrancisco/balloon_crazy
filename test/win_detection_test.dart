import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/domain/game_session.dart';

void main() {
  test('win is not declared while an active balloon remains', () {
    final session = GameSession(seed: 2);
    session.startNext();

    expect(session.activeBalloon, isNotNull);
    expect(session.phase, SessionPhase.playing);
  });
}
