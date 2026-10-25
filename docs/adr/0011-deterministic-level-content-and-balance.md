# ADR 0011: Make levels deterministic and data-driven

- Status: Accepted for planning
- Date: 2026-10-25

## Context

Difficulty must come from understandable changes in balloon count, spawn gap,
speed, sway, and hazards. Hidden randomness would make balancing and bug
reports unreliable.

## Decision

Each level is a data record containing:

- total balloon count and required target;
- spawn gap, starting speed, maximum speed, and midpoint ramp;
- horizontal sway amount and movement pattern;
- balloon mix, special-balloon counts, and hazard schedule;
- primary objective, optional objectives, lives, and expected duration;
- a deterministic seed for replay and test fixtures.

The initial twelve-level balance sheet in `version-2-game-design.md` is the
baseline. It is tuning data, not a promise that the first playtest values are
final. The game must preserve at least 20% safely catchable balloons. Speed may
ramp by at most 10% during a level and must not exceed its declared maximum.

## Consequences

Designers can adjust a level without changing engine code. Tests can replay a
reported seed. Balance changes must update the level data and changelog, not
random constants scattered through Flame components.

