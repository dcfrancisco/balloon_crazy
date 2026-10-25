# ADR 0012: Use explicit objectives and non-paywalled progression

- Status: Accepted for planning
- Date: 2026-10-25

## Context

The original game has a clear action but no reason to replay a successful run.
V2 needs goals that teach risk management without turning progression into a
store or account system.

## Decision

Every level has one required objective and up to two optional star objectives.
Supported objective types are catch count, banked stack size, score, lives
remaining, combo count, special-balloon collection, survival time, and
hazard avoidance.

- One star means the required objective is complete.
- Two stars include the first optional objective.
- Three stars complete all objectives.
- The next level unlocks from the required objective only.
- Stars unlock cosmetic palettes or presentation variants, never gameplay power.
- Objective progress is visible during play and shown again on the results screen.

## Consequences

Objectives become testable domain events rather than UI-only counters. The
player can progress offline, replay any unlocked level, and understand why a
run succeeded or failed.

