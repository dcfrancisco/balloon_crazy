import 'package:balloon_crazy/features/adventure/domain/level_catalog.dart';
import 'package:balloon_crazy/features/adventure/domain/level_definition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('V2 level catalog', () {
    test('starts with the approved Levels 1 through 3 slice', () {
      expect(v2Levels.map((level) => level.number), [1, 2, 3]);
      expect(v2LevelByNumber(1)?.name, 'First Lift');
      expect(v2LevelByNumber(4), isNull);
    });

    test('all authored levels satisfy their tuning contract', () {
      for (final level in v2Levels) {
        expect(level.validate(), isEmpty, reason: 'Level ${level.number}');
      }
    });

    test('difficulty increases across the first slice', () {
      expect(
        v2Levels[0].tuning.startSpeed,
        lessThan(v2Levels[1].tuning.startSpeed),
      );
      expect(
        v2Levels[1].tuning.startSpeed,
        lessThan(v2Levels[2].tuning.startSpeed),
      );
      expect(
        v2Levels[0].tuning.spawnGapSeconds,
        greaterThan(v2Levels[2].tuning.spawnGapSeconds),
      );
      expect(v2Levels[0].tuning.swayPercent, 0);
      expect(v2Levels[2].tuning.swayPercent, 8);
    });

    test('tutorial slice has no hazards or special balloons', () {
      for (final level in v2Levels) {
        expect(level.tuning.hazardCount, 0);
        expect(level.tuning.balloonMix.keys, [V2BalloonKind.normal]);
      }
    });

    test('rejects mismatched spawn totals and excessive speed ramp', () {
      const invalid = V2LevelDefinition(
        number: 1,
        name: 'Invalid',
        region: V2Region.meadow,
        difficulty: V2DifficultyTier.tutorial,
        seed: 1,
        startingLives: 4,
        primaryObjective: V2Objective(
          type: V2ObjectiveType.catchCount,
          target: 1,
          label: 'Catch one',
        ),
        optionalObjectives: [],
        introducedRule: 'Validation fixture',
        tuning: V2LevelTuning(
          totalSpawnCount: 2,
          spawnGapSeconds: 1,
          startSpeed: 100,
          maxSpeed: 110,
          swayPercent: 0,
          midpointRampPercent: 11,
          movementPattern: V2MovementPattern.straight,
          balloonMix: {V2BalloonKind.normal: 1},
          expectedDurationSeconds: (minimum: 10, maximum: 20),
        ),
      );

      expect(
        invalid.validate(),
        containsAll([
          'Balloon mix must equal the total spawn count.',
          'Midpoint speed ramp cannot exceed 10%.',
        ]),
      );
    });
  });
}
