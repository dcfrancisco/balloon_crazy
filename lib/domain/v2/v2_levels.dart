import 'level_definition.dart';

const v2Levels = <V2LevelDefinition>[
  V2LevelDefinition(
    number: 1,
    name: 'First Lift',
    region: V2Region.meadow,
    difficulty: V2DifficultyTier.tutorial,
    seed: 2001,
    startingLives: 4,
    primaryObjective: V2Objective(
      type: V2ObjectiveType.catchCount,
      target: 8,
      label: 'Catch 8 balloons',
    ),
    optionalObjectives: [
      V2Objective(
        type: V2ObjectiveType.livesRemaining,
        target: 4,
        label: 'Finish with all 4 lives',
      ),
      V2Objective(
        type: V2ObjectiveType.combo,
        target: 3,
        label: 'Reach a 3 catch combo',
      ),
    ],
    introducedRule: 'Move and catch',
    tuning: V2LevelTuning(
      totalSpawnCount: 10,
      spawnGapSeconds: 1.20,
      startSpeed: 150,
      maxSpeed: 165,
      swayPercent: 0,
      movementPattern: V2MovementPattern.straight,
      balloonMix: {V2BalloonKind.normal: 10},
      expectedDurationSeconds: (minimum: 45, maximum: 60),
    ),
  ),
  V2LevelDefinition(
    number: 2,
    name: 'Safe Stack',
    region: V2Region.meadow,
    difficulty: V2DifficultyTier.tutorial,
    seed: 2002,
    startingLives: 4,
    primaryObjective: V2Objective(
      type: V2ObjectiveType.bankStack,
      target: 4,
      label: 'Bank a stack of 4',
    ),
    optionalObjectives: [
      V2Objective(
        type: V2ObjectiveType.catchCount,
        target: 8,
        label: 'Catch 8 balloons',
      ),
      V2Objective(
        type: V2ObjectiveType.livesRemaining,
        target: 4,
        label: 'Finish with all 4 lives',
      ),
    ],
    introducedRule: 'Bank a safe stack',
    tuning: V2LevelTuning(
      totalSpawnCount: 12,
      spawnGapSeconds: 1.15,
      startSpeed: 155,
      maxSpeed: 170,
      swayPercent: 5,
      movementPattern: V2MovementPattern.gentleSway,
      balloonMix: {V2BalloonKind.normal: 12},
      expectedDurationSeconds: (minimum: 50, maximum: 65),
    ),
  ),
  V2LevelDefinition(
    number: 3,
    name: 'Keep Moving',
    region: V2Region.meadow,
    difficulty: V2DifficultyTier.normal,
    seed: 2003,
    startingLives: 4,
    primaryObjective: V2Objective(
      type: V2ObjectiveType.score,
      target: 180,
      label: 'Score 180 points',
    ),
    optionalObjectives: [
      V2Objective(
        type: V2ObjectiveType.combo,
        target: 4,
        label: 'Reach a 4 catch combo',
      ),
      V2Objective(
        type: V2ObjectiveType.livesRemaining,
        target: 3,
        label: 'Finish with at least 3 lives',
      ),
    ],
    introducedRule: 'Faster spawn cadence',
    tuning: V2LevelTuning(
      totalSpawnCount: 16,
      spawnGapSeconds: 1,
      startSpeed: 175,
      maxSpeed: 195,
      swayPercent: 8,
      movementPattern: V2MovementPattern.gentleSway,
      balloonMix: {V2BalloonKind.normal: 16},
      expectedDurationSeconds: (minimum: 55, maximum: 70),
    ),
  ),
];

V2LevelDefinition? v2LevelByNumber(int number) {
  for (final level in v2Levels) {
    if (level.number == number) return level;
  }
  return null;
}

