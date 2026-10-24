# ADR 0001: Adopt a deterministic domain-first game architecture

- Status: Accepted for recovery
- Date: 2026-10-25
- Owners: Game engineering and product
- Decision horizon: Recovery milestone through first mobile release
- Related: `docs/architecture-review.md`, `docs/gameplay-rules-v1.md`, ADR 0002

## Context

Balloon Crazy is a Flutter application using Flame for its real-time scene. The prototype currently places gameplay rules across the root `FlameGame`, `Player`, `Balloon`, timers, collision callbacks, Flutter overlays, and local persistence code.

This makes apparently small changes risky:

- a collision callback changes score and difficulty;
- a component-owned timer performs banking and later mutates score;
- the game root selects balloons, determines victory, manages overlays, maps input, and owns UI listenables;
- end-state UI reads mutable live game values;
- tests must mount Flame objects or bypass their lifecycle.

The design reference, README, and runtime also disagree on fundamental rules. Without an authoritative state model, engineers cannot tell whether a behavior is intended, accidental, or incomplete.

The game is small. A large framework, backend, ECS migration, or full rewrite would add delivery risk without solving the central problem: rules and session transitions are not explicit or deterministic.

## Decision

We will retain Flutter for the application shell and Flame for rendering, collision observation, animation, and input. We will move authoritative gameplay state and rules into a pure Dart domain model named `GameSession`.

The model will:

1. Have no imports from Flutter or Flame.
2. Accept explicit commands and elapsed time.
3. Produce a new state and domain events.
4. Receive randomness through an injected, seedable `RandomSource`.
5. Enforce legal phase transitions and terminal-state immutability.
6. Carry a unique session ID so delayed effects from an old run are ignored or cancelled.
7. Use a versioned `Ruleset` object for tuning values rather than scattered constants.

The Flame layer will be an adapter. Components will display domain entities and report observations such as movement intent or a collision candidate. They will not award points, remove lives, decide banking, or decide win/game over.

The Flutter shell will own app lifecycle and overlay presentation. A game coordinator will translate domain events into presentation effects such as animation, sound, haptics, and leaderboard navigation.

Local scores will be accessed through an injected `LeaderboardRepository`. The first implementation remains SharedPreferences-backed, but storage format and recovery are isolated from the game.

## Canonical recovery ruleset

For the recovery milestone, the canonical mode will be **Original Inspired v1**:

- portrait, fixed logical playfield;
- four rows of fifteen balloons;
- rows deplete in a defined sequence;
- one active falling balloon at a time;
- four initial lives;
- caught balloons visibly stack and raise the player/catch point;
- catch speed increases within a bank cycle and resets after banking;
- bank threshold is derived from the active row;
- a miss loses one life and clears held balloons;
- caught balloons are unbanked risk; each balloon scores 10 only when banked;
- all balloons cleared means win; zero lives means game over;
- both terminal outcomes flow through the same results/leaderboard path.

Exact rules and intentional corrections to the BASIC listing are settled in `docs/gameplay-rules-v1.md` and ADR 0002. Tuning values remain data in `Ruleset`, but changing a rule requires a versioned ruleset rather than silently changing v1.

Colored balloon tiers, bouncing, levels, power-ups, online leaderboards, and monetization are out of scope until this mode is complete and measurable.

## State and interaction model

The minimum domain state is:

```dart
enum GamePhase { ready, playing, resolvingMiss, banking, won, gameOver, paused }

final class GameSession {
  final String id;
  final GamePhase phase;
  final int score;
  final int lives;
  final int activeRow;
  final int heldBalloons;
  final double fallSpeed;
  final double playerX;
  final BalloonState? fallingBalloon;
  final List<RowState> rows;
  final int revision;
}
```

Representative commands:

```text
StartSession
Advance(elapsed)
MovePlayer(normalizedX)
RegisterCatch(balloonId)
RegisterMiss(balloonId)
CompleteEffect(effectId, sessionId)
Pause / Resume
```

Representative events:

```text
BalloonDropped, BalloonCaught, BankStarted, BalloonBanked,
LifeLost, SessionWon, SessionLost, ScoreChanged
```

Events describe facts. Audio and animation subscribe to them but cannot alter rules. Completion commands are accepted only when their session and effect IDs match current state.

## Runtime boundaries

### Pure domain

- `GameSession`, immutable value objects, commands, events, transition reducer.
- `Ruleset`, including row layout, thresholds, speeds, score values, and lives.
- `RandomSource` abstraction and seeded implementation for tests.
- Invariant validation in debug/test builds.

### Application coordinator

- Owns the current session and dispatch queue.
- Serializes commands to avoid collision/restart races.
- Maps domain events to effect requests.
- Cancels or rejects old-session work.
- Publishes immutable snapshots for Flame and Flutter.

### Flame adapter

- Creates and synchronizes visual components by stable entity ID.
- Converts pointer coordinates into normalized movement input.
- Detects contacts, then sends collision candidates to the coordinator.
- Runs animations and reports effect completion.
- Does not own score, lives, rules, random selection, or terminal decisions.

### Flutter shell

- Owns app lifecycle, accessibility, safe areas, orientation, and menus.
- Selects overlays from the published phase/result snapshot.
- Pauses the session on lifecycle interruption.
- Captures an immutable `GameResult` before allowing restart.

### Persistence and device services

- `LeaderboardRepository` validates and versions stored data.
- `AudioPort` and `HapticsPort` respect user settings and device lifecycle.
- Implementations are injected at the composition root.

## Invariants

These constraints must be executable assertions/tests:

- Lives never fall below zero.
- Score never decreases within a session.
- At most one active balloon exists in Original Inspired v1.
- A balloon ID can be caught or missed once, never both.
- A terminal session cannot accept gameplay commands.
- Banking cannot overlap a miss or another bank.
- Restart creates a new session ID and no old event can mutate it.
- Queued + active + caught + missed/banked balloons equals the ruleset total.
- Win occurs only when no queued, active, or unresolved balloon remains.
- The same ruleset, seed, timestep sequence, and commands produce the same event sequence.

## Timing policy

Gameplay truth must not depend on wall-clock delays or widget animation duration.

- Simulation accepts elapsed seconds and clamps pathological frame gaps.
- Presentation effects may take real time, but domain phases explicitly wait for identified completion when necessary.
- Tests advance a fake clock; they do not call `Future.delayed`.
- Backgrounding pauses simulation immediately. Resume requires an explicit player action after longer interruptions.

## Error and data policy

- Invalid commands are ignored with a structured diagnostic in debug builds; they do not partially mutate state.
- Corrupt or unknown leaderboard payloads are quarantined/reset to an empty local board rather than crashing startup.
- Storage has a schema version and migration entry point.
- No gameplay code directly calls SharedPreferences.
- Diagnostics must not include player-entered names unless explicitly consented and required.

## Testing strategy

### Domain tests — majority of coverage

- Transition table for every phase and command.
- Full-session simulations for win, loss, and restart.
- Threshold and scoring tables for every row.
- Seed replay/determinism test.
- Property tests for invariants when practical.
- Regression test for old-session bank/miss completion after restart.

### Adapter tests — focused integration

- Flame collision produces one command for one entity ID.
- Domain snapshots create/update/remove the expected components.
- Coordinate mapping works at representative aspect ratios.
- Pause prevents simulation advancement.

### UI and persistence tests

- Ready, paused, results, leaderboard, and name-entry widgets.
- Win and game-over both capture the final score before restart.
- Repository sorting, ties, trimming, migration, and malformed JSON recovery.
- Golden tests for small phone, tall phone, and tablet layouts.

### Release checks

- Static analysis and all tests on every pull request.
- Android debug build on every pull request.
- Signed Android/iOS internal builds on release candidates.
- Physical-device smoke checklist for touch, lifecycle, sound, and performance.

## Migration plan

Migration is incremental and keeps the prototype runnable:

1. **Toolchain gate** — pin Flutter/Dart, commit the lockfile, restore green analysis/tests, and add CI.
2. **Rules gate** — approve `gameplay-rules-v1.md` and update public-facing copy.
3. **Characterization gate** — capture intentionally retained behavior before moving it.
4. **Domain skeleton** — add `Ruleset`, `GameSession`, phases, commands, events, seeded randomness, and pure tests.
5. **Coordinator seam** — make the current game dispatch start, move, catch, miss, and restart commands while visuals remain mostly unchanged.
6. **Authority transfer** — remove score/life/rule mutation from `Player`, `Balloon`, and timers; render snapshots instead.
7. **Results/persistence** — unify terminal flows and inject the repository.
8. **Game-feel pass** — reconnect animations, sound, haptics, and difficulty using domain events.
9. **Delete compatibility paths** — remove obsolete mutable fields and tests that bypass component lifecycle.

Each step must land with a green build. Do not run a long-lived parallel rewrite branch.

## Options considered

### Keep the current component-driven design and patch defects

Rejected. It is cheapest for one defect but preserves split authority and makes every new mechanic more race-prone.

### Rewrite the whole game in Flutter widgets

Rejected. Flutter can render this game, but leaving Flame does not itself create deterministic rules and would discard useful collision/animation infrastructure.

### Adopt a full ECS or another game engine

Rejected for the first release. The entity count and mechanic scope do not justify migration cost. This can be revisited only if future modes demonstrate a real scaling constraint.

### Put all state in a general Flutter state-management package

Rejected as the primary solution. A notifier/provider can publish snapshots, but generic UI state management does not define simulation semantics, determinism, or session isolation.

### Domain-first Flutter/Flame architecture

Chosen. It directly addresses the observed failure modes, is testable without a renderer, supports deterministic replay, and can be introduced incrementally.

## Consequences

Positive:

- Gameplay rules become reviewable and testable in plain Dart.
- Flame remains focused on the work it does well.
- Restarts, lifecycle events, and animations cannot mutate the wrong session.
- Difficulty tuning becomes data-driven.
- Replays and deterministic bug reproduction become possible later.
- The repository can grow without a disproportionate rise in test complexity.

Costs:

- A small amount of mapping code is required between domain entities and Flame components.
- Engineers must resist placing rule mutations in collision or animation callbacks.
- During migration, old and new paths briefly coexist behind explicit seams.
- Product must resolve contradictory rules before implementation can be considered complete.

## Non-goals

- No backend or account system.
- No online/anti-cheat leaderboard.
- No multiplayer.
- No generalized plugin architecture.
- No speculative level editor or content pipeline.
- No engine rewrite.

## Acceptance criteria

This ADR is implemented when:

- the canonical ruleset is documented and represented by `Ruleset`;
- a complete win and loss can be simulated in pure Dart with a seed;
- Flame components contain no authoritative scoring, life, banking, or terminal-state decisions;
- restart and app lifecycle race regressions are covered;
- win and game-over share an immutable result flow;
- persistence is behind an injected repository with corruption recovery;
- CI analyzes, tests, and builds the supported mobile targets;
- the old mutable gameplay authority is removed rather than retained indefinitely.

## Follow-up decisions

- ADR 0002: supported Flutter/Dart version, dependency update policy, and CI matrix.
- ADR 0002: canonical gameplay, scope, boundaries, constraints, and assumptions.
- ADR 0003: mobile distribution, privacy, identity, and release quality gates.
- ADR 0004: asset pipeline, provenance, and runtime dependency policy.
