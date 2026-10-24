# ADR 0007: Fixed-viewport input and swept vertical collision

Date: 2026-10-25  
Status: accepted

## Context

The vertical slice uses Flame's fixed 820×1600 world inside a responsive
Flutter layout. Mapping a touch by widget width alone is wrong when the game
is letterboxed, and relying only on overlap callbacks can tunnel a balloon
through the player when a frame advances more than one collision width.

## Decision

Use one tested `GameCoordinateMapper` for all touch entry points. It computes
the uniform scale and letterbox offsets, then clamps the result to the fixed
world before moving the player.

Use a swept vertical crossing check for the active balloon. The projection
checks the balloon's previous and next positions against the player and floor,
so a downward crossing is resolved once even when a frame is large. The
rules-engine entity ID remains the authority guard against stale callbacks.

## Consequences

- Controls behave consistently across portrait phones, tablets, and test
  layouts with different aspect ratios.
- Collision correctness no longer depends on Flame overlap timing.
- The vertical slice remains dependency-light and keeps gameplay decisions in
  `GameSession`.
- Physical-device playtesting is still required to validate feel, safe-area
  behavior, and player comprehension.

