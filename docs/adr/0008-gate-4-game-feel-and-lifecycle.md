# ADR 0008: Improve game feel before production assets

## Status

Accepted — Gate 4, Pass 1.

## Context

The deterministic rules and Flame projection are playable, but the current
vertical slice does not clearly communicate the player's held-balloon risk,
does not pause safely when Android backgrounds the app, and gives weak feedback
for catches, misses, and banking. Adding new art before these problems are
resolved would make playtest results harder to interpret.

## Decision

Use the existing sprites and rules to add a small game-feel layer:

- expose the held stack in the HUD;
- show immediate catch, miss, and bank feedback;
- provide an explicit pause/resume overlay;
- pause automatically when Android sends the app to an inactive/background
  lifecycle state;
- keep the canonical score, lives, thresholds, and progression unchanged.

Production sprite, audio, haptics, and monetization work remain later Gate 4
items and require their own asset/provenance review.

## Consequences

The player can understand risk and recover safely from interruptions during an
Android session. The feedback layer is presentation-only and is driven by the
existing domain events. Physical-device testing remains required before Gate 3
and Gate 4 are declared complete.
