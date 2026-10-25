# ADR 0015: Require measured playtest evidence before expanding V2

- Status: Accepted for planning
- Date: 2026-10-25

## Context

The level numbers are a reasoned starting point, not proof of fun or fairness.
Building all twelve levels before observing real players would repeat the
project's previous cycle of long implementation without reliable feedback.

## Decision

V2 development proceeds in slices:

1. Implement and instrument Levels 1–3.
2. Test on the target Android device and a slower Android profile.
3. Record completion rate after three attempts, median duration, misses,
   maximum stack, and objective completion.
4. Tune speed/spawn gap/sway before adding new hazards or art.
5. Expand to Levels 4–6 only when the first slice is stable and understandable.

Balance rules are explicit: if fewer than 70% of new players finish after three
attempts, reduce speed by 10%; if more than 90% finish on the first attempt,
increase spawn pressure or add an optional objective before increasing speed.

## Consequences

Every level expansion has evidence and a reproducible baseline. Playtest data
can change tuning values without changing the game's core promise or its V1
release.

