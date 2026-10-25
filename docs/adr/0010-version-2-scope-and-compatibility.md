# ADR 0010: Define Version 2 as an additive game layer

- Status: Accepted for planning
- Date: 2026-10-25

## Context

Version 1 is the stable downloadable Android release. Version 2 needs a real
game structure without losing the original catch, stack, bank, and miss loop.
Rewriting the V1 rules while adding new content would make regressions hard to
diagnose and would delay the playable artifact.

## Decision

- V2 is additive: it introduces level content, objectives, difficulty, and
  progression around the canonical V1 interaction.
- V1 remains a supported ruleset and is not silently changed by V2 content.
- Arcade is the first V2 playable mode; Adventure is implemented after the
  first three levels have been playtested.
- Retro is optional and may reuse the V1 presentation. Multiplayer, accounts,
  online services, ads, purchases, and procedural generation are out of scope.
- V2 content must be selectable through explicit mode/level state, not inferred
  from screenshots, asset presence, or a hidden global flag.

## Consequences

The rules engine needs a versioned level definition and mode identifier. The
existing V1 APK remains a useful comparison build, and a V2 failure cannot
rewrite the player's V1 score or progression.

