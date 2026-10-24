# Balloon Crazy architecture and product review

Date: 2026-10-25  
Scope: Flutter/Flame client, original BASIC, gameplay model, assets, tests, local persistence, Android/iOS configuration, and public-release readiness.

## Executive assessment

Balloon Crazy is a recoverable prototype, not a release candidate. Flutter and Flame are suitable and the existing retro character/balloon art gives the project an identity worth retaining. The project stalled because it lacks a single gameplay authority, an agreed rules contract, a reproducible toolchain, and an end-to-end release definition.

The recovery is deliberately smaller than the README's implied product: ship one polished, finite, offline arcade mode. Do not rewrite engines or add features until the original-inspired vertical slice is fun, deterministic, and green in CI.

Current readiness: **pre-alpha**.

## Evidence-based diagnosis

### Release blockers (P0)

1. **The configured toolchain cannot execute.** `pubspec.yaml` requires Dart `3.44.0`, no `pubspec.lock` is committed, and the configured Flutter installation contains Dart 3.3.4, which aborts in `cpuinfo_macos.cc` before version, analysis, or tests complete. A fresh build is not reproducible.
2. **Store identity and signing are placeholders.** Android uses `com.example.balloon_crazy` and the debug key for release. iOS uses `com.example.balloonCrazy`. The permanent owner-controlled identifier, signing secrets, application records, and version policy are absent.
3. **Rights/provenance are not demonstrated.** The repository MIT license does not by itself establish redistribution rights for the magazine BASIC listing, title, fonts, sounds, screenshots, or all art. README names two font license files that are not tracked. Public beta must wait for a provenance ledger and replacement of anything unclear.
4. **There is no build/release automation.** No CI proves formatting, analysis, tests, Android App Bundle, or iOS archive. There is no internal-track checklist or rollback/versioning process.

### Core-game blockers (P1)

5. **Three rule sources describe different games.** The BASIC, gameplay reference/README, and runtime disagree on row order, scoring, balloon concurrency, grid size, banking, speed, and progression. The old reference incorrectly says catches score and calls `BP=3 → 0` top-to-bottom; the BASIC scores only in banking and starts at the lowest drawn row.
6. **Rules live inside rendering objects and asynchronous effects.** The root game, player, balloon, timers, collision callbacks, overlays, and persistence all mutate outcome-related state. `Player.bank()` can finish after restart and change the new score.
7. **The current runtime does not implement its advertised loop.** It creates 4×10 balloons, starts multiple concurrent drops, always uses a red balloon, keeps `bankPenalty` at zero, increments a speed value that does not drive velocity, never raises the player, and awards points both on catch and bank.
8. **State transitions are not atomic.** Game over can leave components active; life loss resets the player while other balloons fall; any non-playing tap can restart; result capture reads mutable live score; timers/effects do not share cancellation/session identity.
9. **Input mapping is presentation-dependent and under-tested.** A `FittedBox`, fixed logical camera, widget-width feedback, camera conversion, and direct position mutation create multiple coordinate paths. Pan start lacks the same clamping as pan update.
10. **The common loss path cannot save a score.** Only win opens `WonPrompt`; game over restarts on tap. A local leaderboard that excludes most completed sessions is not coherent.

### Quality and experience gaps (P2)

11. **Tests express intent but are not a safety net.** Tests dynamically assign Flame internals, duplicate production win logic, expect an overlay that was never registered, and retain a generated counter test. There are no full-session, race, lifecycle, viewport, or malformed-storage tests.
12. **Lifecycle and accessibility policies are absent.** There is no pause/resume behavior, reduced-motion response, audio/haptic settings, semantic navigation, or deliberate minimum touch/text sizing. iOS currently permits landscape despite a portrait-shaped game.
13. **Assets are visually inconsistent and incomplete.** The attractive large player art is downscaled to a tiny playfield sprite; balloon files use multiple sizes/styles; the pop image is a horizontal strip with unclear frame metadata; required fall/tumble/life states are missing or substituted. Sounds are packaged but no audio integration exists.
14. **Runtime font behavior and documentation conflict.** UI uses `google_fonts` at runtime while the declared bundled Press Start license/file is absent. A release should bundle the chosen font and work fully offline.
15. **Persistence is fragile.** `LeaderboardService` instantiates storage internally and trusts decoded JSON shapes. Corruption or schema drift can break UI, and time/name handling is not policy-driven.
16. **Ownership cleanup is needed.** Game-created `ValueNotifier`s are not disposed; mutable public fields permit invalid state; `WonPrompt` calls `setState` after an await without first checking `mounted`.

## What should remain

- Flutter for the mobile shell and Flame for real-time rendering/input/effects.
- A fixed logical playfield inside a responsive safe-area-aware shell.
- The red balloon, colorful title, blue field, and playful pixel skater as the visual essence.
- One-at-a-time balloon focus, stack growth, automatic bank thresholds, four lives, and finite-board victory.
- Local-only scores and offline-first behavior.
- Small architecture: domain, coordinator, Flame adapter, Flutter presentation, and device/persistence ports.

## Target architecture

```text
Flutter app shell
  lifecycle • overlays • settings • accessibility • result UI
                         |
Game coordinator
  serialized commands • session identity • effect cancellation
                         |
Pure Dart domain
  GameSession • Ruleset • commands/events • seeded random • invariants
                         |
Flame adapter
  visual projection • input transform • collision candidates • effects

Ports: LeaderboardRepository • AudioPort • HapticsPort • Clock • RandomSource
```

The domain owns whether something happened. Flame owns how it looks. Flutter owns mobile/application concerns. Effects never own score, lives, progression, or terminal state.

## Recommended source boundaries

```text
lib/
  app/                    composition, theme, lifecycle, navigation
  game/
    domain/               pure rules, values, commands, events
    application/          coordinator and effect orchestration
    flame/                camera, render components, input/collision adapter
    presentation/         HUD, pause, onboarding, results
  leaderboard/            model, repository port, local adapter
  settings/               local audio, haptics, motion preferences
```

This is a direction, not permission to create empty layers or abstract single-use code. Add each boundary only while moving real behavior behind it.

## Decision summary

- ADR 0001 makes the game deterministic and domain-first without leaving Flutter/Flame.
- ADR 0002 chooses the bank-to-score `Original Inspired v1` contract and narrows scope.
- ADR 0003 defines distribution, privacy, device support, and release gates.
- ADR 0004 keeps dependencies minimal and blocks unknown-provenance assets.

## Recovery priorities

1. Establish legal/provenance and permanent app identity decisions in parallel with toolchain repair.
2. Pin a working Flutter release, restore a committed lockfile, and get honest analysis/tests green.
3. Implement the rules spec as a pure deterministic session with full transition tests.
4. Reconnect one input path and one-balloon Flame projection; then restore effects/audio.
5. Complete results, local persistence recovery, lifecycle pause, settings, and accessibility.
6. Curate/generate only the missing sprite states under the approved asset brief.
7. Prove both signed internal builds and pass store/release checklists.

## Verification performed

- Reviewed every tracked Dart source and test file, package configuration, platform configuration, repository history, screenshots, image/audio metadata, original BASIC listing, README, and prior untracked documentation.
- Visually inspected the two captured gameplay screens and principal character/balloon/pop assets.
- Attempted `flutter --version`, `flutter analyze`, and `flutter test`; all abort in the locally configured Dart 3.3.4 VM before project analysis begins. No claim of a passing or failing suite is made.
- Store requirements were checked against official Apple, Google, and Flutter documentation on 2026-10-25; volatile numeric requirements must be rechecked at release.
