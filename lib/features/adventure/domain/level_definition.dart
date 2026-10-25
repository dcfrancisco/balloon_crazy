enum V2DifficultyTier { tutorial, normal, fast, hard, challenge }

enum V2Region { meadow, twilight, summit }

enum V2ObjectiveType {
  catchCount,
  bankStack,
  score,
  livesRemaining,
  combo,
  collectSpecial,
  surviveSeconds,
  avoidHazards,
}

enum V2MovementPattern { straight, gentleSway, splitPath, patterned }

enum V2BalloonKind { normal, gold, striped, heart, crystal, skull, rainbow }

class V2Objective {
  const V2Objective({
    required this.type,
    required this.target,
    required this.label,
    this.balloonKind,
  });

  final V2ObjectiveType type;
  final int target;
  final String label;
  final V2BalloonKind? balloonKind;
}

class V2LevelTuning {
  const V2LevelTuning({
    required this.totalSpawnCount,
    required this.spawnGapSeconds,
    required this.startSpeed,
    required this.maxSpeed,
    required this.swayPercent,
    required this.movementPattern,
    required this.balloonMix,
    required this.expectedDurationSeconds,
    this.midpointRampPercent = 10,
  });

  /// Includes normal, special, and hazard balloons in the scheduled run.
  final int totalSpawnCount;
  final double spawnGapSeconds;
  final double startSpeed;
  final double maxSpeed;
  final int swayPercent;
  final int midpointRampPercent;
  final V2MovementPattern movementPattern;
  final Map<V2BalloonKind, int> balloonMix;
  final ({int minimum, int maximum}) expectedDurationSeconds;

  int get scheduledSpawnCount =>
      balloonMix.values.fold(0, (total, count) => total + count);

  int get hazardCount => balloonMix[V2BalloonKind.skull] ?? 0;
}

class V2LevelDefinition {
  const V2LevelDefinition({
    required this.number,
    required this.name,
    required this.region,
    required this.difficulty,
    required this.seed,
    required this.startingLives,
    required this.primaryObjective,
    required this.optionalObjectives,
    required this.introducedRule,
    required this.tuning,
  });

  final int number;
  final String name;
  final V2Region region;
  final V2DifficultyTier difficulty;
  final int seed;
  final int startingLives;
  final V2Objective primaryObjective;
  final List<V2Objective> optionalObjectives;
  final String introducedRule;
  final V2LevelTuning tuning;

  List<String> validate() {
    final errors = <String>[];
    if (number < 1) errors.add('Level number must be positive.');
    if (name.trim().isEmpty) errors.add('Level name is required.');
    if (seed < 0) errors.add('Seed must not be negative.');
    if (startingLives < 1) errors.add('At least one life is required.');
    if (primaryObjective.target < 1) {
      errors.add('Primary objective target must be positive.');
    }
    if (optionalObjectives.length > 2) {
      errors.add('A level can have at most two optional objectives.');
    }
    if (tuning.totalSpawnCount < 1) {
      errors.add('A level must schedule at least one balloon.');
    }
    if (tuning.scheduledSpawnCount != tuning.totalSpawnCount) {
      errors.add('Balloon mix must equal the total spawn count.');
    }
    if (tuning.spawnGapSeconds <= 0) {
      errors.add('Spawn gap must be greater than zero.');
    }
    if (tuning.startSpeed <= 0 || tuning.maxSpeed < tuning.startSpeed) {
      errors.add('Speed range is invalid.');
    }
    if (tuning.swayPercent < 0 || tuning.swayPercent > 100) {
      errors.add('Sway percent must be between 0 and 100.');
    }
    if (tuning.midpointRampPercent < 0 || tuning.midpointRampPercent > 10) {
      errors.add('Midpoint speed ramp cannot exceed 10%.');
    }
    if (tuning.expectedDurationSeconds.minimum < 1 ||
        tuning.expectedDurationSeconds.maximum <
            tuning.expectedDurationSeconds.minimum) {
      errors.add('Expected duration range is invalid.');
    }
    return errors;
  }
}
