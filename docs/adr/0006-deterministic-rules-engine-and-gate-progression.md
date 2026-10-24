# ADR 0006: Deterministic rules engine before presentation expansion

Date: 2026-10-25  
Status: accepted

## Context

The existing Flame shell is playable, but its prototype scheduler and score
updates do not implement the canonical v1 rules: it can have multiple falling
balloons, uses a 40-balloon grid, and awards points on catch. Fixing those rules
inside collision callbacks would make them difficult to test and would risk
changing behavior during animation or lifecycle interruptions.

## Decision

Gate 2 is implemented first as a dependency-free Dart rules engine in
`lib/domain/game_session.dart`. It owns seeded selection, one active balloon,
catch/miss crossing, held-stack risk, source-row banking thresholds, score,
lives, pause, and terminal outcomes. Its internal state is mutated only through
rules methods and it emits domain events; Flame and Flutter remain projections
of those events. A later hardening pass may expose immutable snapshots at the
adapter boundary.

The current visual shell remains available while the projection is migrated.
No new production art or gameplay variant is introduced during this gate.

## Consequences

- Rules can be verified with fast plain Dart/Flutter tests and replayed from a
  seed.
- The shell must stop owning score/life truth before Gate 3 is complete.
- Existing prototype tests that assert catch-time scoring are obsolete and must
  be replaced by canonical rules tests.
- The playable artifact may use the existing assets until Gate 4; asset creation
  is explicitly not a prerequisite for the vertical slice.

## Gate status

- Gate 0: open (publisher/legal identity and provenance remain owner work).
- Gate 1: complete on the current branch (toolchain, lockfile, analysis, tests,
  and Android debug verification are documented).
- Gate 2: in progress; deterministic rules core and acceptance tests are now
  present. Projection migration is the next implementation step.
- Gate 3: blocked until the projection consumes `GameSession` events.
