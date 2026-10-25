import 'package:balloon_crazy/features/adventure/application/level_one_controller.dart';
import 'package:balloon_crazy/features/adventure/domain/level_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'level one starts in briefing and only creates the board after start',
    () {
      final controller = V2LevelOneController();

      expect(controller.phase, V2LevelOnePhase.briefing);
      expect(controller.catches, 0);

      controller.begin();

      expect(controller.phase, V2LevelOnePhase.playing);
      expect(controller.balloonY, 0);
    },
  );

  test(
    'catching the target ends the level with objective progress complete',
    () {
      final controller = V2LevelOneController()..begin();

      for (var i = 0; i < controller.target; i++) {
        controller.movePlayer(controller.balloonX);
        controller.tick(10);
      }

      expect(controller.phase, V2LevelOnePhase.results);
      expect(controller.outcome, V2LevelOneOutcome.won);
      expect(controller.catches, 8);
      expect(controller.objectiveProgress, 1);
    },
  );

  test('missing balloons costs lives and clears the held stack', () {
    final controller = V2LevelOneController()..begin();
    controller.movePlayer(0.08);
    controller.tick(12);

    expect(controller.misses, 1);
    expect(controller.lives, v2Levels.first.startingLives - 1);
    expect(controller.held, 0);
    expect(controller.phase, V2LevelOnePhase.playing);
  });

  test('results screen can restart a deterministic level', () {
    final controller = V2LevelOneController()..begin();
    controller.movePlayer(0.08);
    for (var i = 0; i < v2Levels.first.startingLives; i++) {
      controller.tick(12);
    }

    expect(controller.phase, V2LevelOnePhase.results);
    controller.restart();

    expect(controller.phase, V2LevelOnePhase.briefing);
    expect(controller.catches, 0);
    expect(controller.lives, 4);
  });
}
