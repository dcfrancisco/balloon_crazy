# ADR 0017: Freeze the tutorial-era V1 shell and build V2 feature-first

- Status: Accepted for implementation
- Date: 2026-10-25

## Context

The released V1 grew from a tutorial project. Its main game class coordinates
rules, rendering, input, overlays, lifecycle, assets, and feedback, while Flame
components call directly back into that class. It is playable, but extending
that coupling across twelve V2 levels would make changes risky and tests slow.

## Decision

- Treat V1 as a frozen compatibility and reference mode. Only release-blocking
  defects are fixed in its existing structure.
- Build V2 in feature-first modules with explicit boundaries:
  - `domain`: immutable level definitions and gameplay rules;
  - `application`: level orchestration and observable state;
  - `presentation`: Flutter/Flame rendering and input adapters;
  - `app`: navigation, theme, lifecycle, and dependency assembly.
- Domain and application code must not depend on Flame components.
- Rendering reads state and emits player intent; it does not award points,
  consume lives, or decide objectives.
- Simulation uses the platform frame scheduler and lifecycle pause/resume,
  never an unmanaged periodic timer.
- V2 remains accessible through `lib/main_v2.dart` until it replaces the main
  app after the vertical slice passes device playtesting.

## Migration rules

1. Implement one complete V2 level through the new boundaries.
2. Extract reusable level/session rules from that slice.
3. Add Levels 2–3 and persistence before changing the default entry point.
4. Retain V1 tests throughout migration.
5. Delete or archive tutorial-era code only after an accepted replacement and
   downloadable comparison build exist.

## Consequences

Some V1 duplication remains temporarily. In exchange, V2 can evolve without a
high-risk rewrite, gameplay stays testable without rendering, and the app has a
clear path from prototype to maintainable product.

