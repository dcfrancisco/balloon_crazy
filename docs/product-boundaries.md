# Balloon Crazy v1 product boundaries

Date: 2026-10-25  
Product state: recovery / pre-alpha  
Target: a small, polished, offline mobile arcade game

## Product promise

Move a skater under one falling balloon at a time. Every catch adds to a taller, faster, riskier stack. Survive long enough to bank the stack for points; a miss costs a life and every unbanked balloon. Clear the board before four misses.

The emotional loop is **read → position → catch → risk grows → bank relief**. Anything that does not strengthen or safely ship that loop is outside the first release.

## In scope for v1

- Android phone and iPhone distribution from one Flutter/Flame codebase.
- Portrait-first, one-handed touch play; keyboard controls remain a development/accessibility aid.
- One mode: `Original Inspired v1`.
- One finite board: four rows of fifteen balloons.
- Four lives, local score, local top-ten leaderboard, pause, sound/haptics settings.
- A short first-run instruction card and replay from either win or loss.
- Fully offline play after installation.
- Retro pixel-art identity, responsive UI shell, safe-area support, and readable touch targets.
- English only for v1, with strings kept out of the simulation and structured for later localization.

## Explicitly out of scope

- Accounts, cloud sync, online leaderboards, backend services, multiplayer, social sharing.
- Advertising, tracking, in-app purchases, subscriptions, loot, or virtual currency.
- Infinite mode, multiple levels, colored balloon powers, bouncing/fire-button mechanics, power-ups, or a level editor.
- Web and desktop store releases.
- A general ECS migration, engine rewrite, generalized plugin system, or broad state-management framework.
- Remote configuration, live operations, mandatory analytics, or mandatory crash reporting.

Out-of-scope work requires a new ADR after the vertical slice meets its quality gate.

## Hard constraints

- The canonical outcome must be deterministic for the same ruleset, seed, elapsed-time sequence, and player commands.
- Gameplay must not require network access or permission prompts.
- A complete session must remain playable on a representative low/mid-range device at a stable 60 Hz target.
- No delayed effect from an old session may mutate a restarted session.
- No store build may use placeholder package identity, debug signing, unknown-license assets, or unverified privacy declarations.
- Release builds must use bundled fonts and assets; gameplay presentation may not depend on a runtime font fetch.
- The logical playfield and UI must remain usable with notches, system bars, text scaling, and common phone aspect ratios.
- Code, asset, and store metadata ownership must be demonstrable before public submission.

## Product constraints that may be tuned

- Fall speed, horizontal catch tolerance, movement response, effect duration, haptic strength, and audio level.
- The target session length is 3–6 minutes for a successful new-player run; tune without changing the rules contract.
- Animation may skip or compress under reduced-motion settings, but rule timing and results cannot change.
- Tablet support may letterbox the playfield; it does not require a tablet-specific game layout for v1.

## Assumptions to validate

| Assumption | How to validate | Failure response |
|---|---|---|
| Direct horizontal drag feels fair and does not hide the catch point | Five-player physical-device test on small and tall phones | Add a lower-screen relative-drag control zone; do not change rules |
| Sixty balloons produces a satisfying short session | Record completion and abandonment times in ten local playtests | Tune speed/effect duration; consider a future shorter mode only via ADR |
| Thresholds 4/5/6/7 create a learnable risk curve | Observe misses and bank completion by tier | Tune tolerance/speed first; version rules if thresholds change |
| Four lives are forgiving enough for first-session learning | At least 3 of 5 new players reach tier two | Improve onboarding and early tuning before changing lives |
| Pixel art remains readable at target phone sizes | Golden review and physical-device screenshots | Re-export nearest-neighbor assets at designed logical sizes |
| A local-only leaderboard adds value without an account | Playtest replay intent and name-entry completion | Keep only best score if name entry causes friction |
| Existing title/source/assets can legally ship | Owner produces provenance and license record | Replace/rename/redraw affected material before beta |

## Definition of playable

A fresh player can discover movement, catch balloons, understand unbanked risk, observe banking, lose a life, pause/resume, finish in win or game over, see an immutable result, save a local score, and immediately replay. No debug knowledge or network is required.

## Definition of publishable

Both store artifacts are reproducibly built and signed from a pinned toolchain; all required tests and physical-device checks pass; identifiers, icons, splash, privacy/support pages, age/content declarations, screenshots, attribution, and asset rights are complete; and internal store tracks show no release-blocking crash, layout, lifecycle, audio, or input defects.
