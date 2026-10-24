# Changelog

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
- Added `./tool/verify.sh` for dependency resolution, formatting, analysis, tests, and Android debug verification.
- Added minimal GitHub Actions verification.
- Recorded the local Xcode 14.2 limitation as an environment-only iOS release blocker.
- No gameplay rules, visual design, or production assets changed.
