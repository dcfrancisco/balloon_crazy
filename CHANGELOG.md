# Changelog

## Unreleased (0.1.x)

- Started Gate 4 Pass 1: added a visible held-balloon stack, catch/miss/bank
  feedback, and Android lifecycle-safe pause/resume behavior without changing
  the canonical rules or adding production assets.

- Added the dependency-free deterministic `GameSession` rules core for Gate 2.
- Added seeded selection, catch/miss, held-stack banking, pause, and terminal
  outcome tests without changing the existing visual assets.
- Recorded ADR 0006 and formalized the Gate 2 projection contract.
- Completed the first Flame projection: one active balloon, canonical catch,
  bank, miss, and terminal transitions now use the rules engine.
- Gate 3 implementation: added fixed-viewport touch mapping with letterbox
  handling and swept balloon/player/floor crossing detection.
- Added automated mapping and large-frame collision regression tests. Physical
  device playtesting remains the final Gate 3 exit requirement.

All notable product and release changes will be documented here.

## 0.1.0+1 — Pre-recovery baseline — 2026-10-25

- Preserved the existing Flutter/Flame prototype before recovery implementation.
- Established canonical Original Inspired v1 gameplay rules and product boundaries.
- Accepted ADRs for deterministic architecture, mobile release gates, asset/dependency policy, and versioning.
- Recorded current blockers: incompatible/broken local Flutter toolchain, missing lockfile/CI, placeholder store identity/signing, inconsistent rules/tests, and incomplete asset provenance.
- No gameplay implementation or new production sprites are included in this baseline.

## Unreleased — Gate 1 technical baseline

- Pinned Flutter 3.35.7 stable and bundled Dart 3.9.x through `.fvmrc`, project constraints, and CI; compatible with the current macOS 12 host.
- Added the resolved `pubspec.lock` and replaced the generated counter test with game welcome/overlay smoke coverage.
- Pinned CI Android builds to Java 17 for Gradle/AGP compatibility.
- Added `./tool/verify.sh` for dependency resolution, formatting, analysis, tests, and Android debug verification.
- Added minimal GitHub Actions verification.
- Recorded the local Xcode 14.2 limitation as an environment-only iOS release blocker.
- No gameplay rules, visual design, or production assets changed.
