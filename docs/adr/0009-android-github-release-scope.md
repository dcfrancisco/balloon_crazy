# ADR 0009: Scope 1.0.0 to a downloadable Android APK

- Status: Accepted
- Date: 2026-10-25
- Owners: Project owner and mobile engineering

## Context

The project owner does not intend to publish through Google Play or the Apple
App Store. The requested outcome is a finished game that can be downloaded
from GitHub.

## Decision

- The first public milestone is an Android-only GitHub release named `1.0.0`.
- The release artifact is a reproducible Flutter release APK attached to the
  GitHub release, with a SHA-256 checksum.
- iOS, app-store submission, TestFlight, store metadata, and store signing are
  cancelled for this release scope.
- The existing gameplay rules, offline behavior, tests, and asset provenance
  remain in force.
- A release build may use the current local/debug signing configuration because
  this APK is for direct download, not store submission. This is documented in
  the release notes.
- CI verifies formatting, analysis, tests, and an Android release APK on the
  `v1.0.0` tag, then publishes the APK and checksum to GitHub Releases.

## Gate changes

- Gate 0: cancelled for store publication; asset provenance remains required.
- Gates 1 and 2: complete.
- Gate 3: complete when the Android vertical slice is verified on the owner's
  device; no five-person study is required.
- Gate 4: finish the offline game loop and user-facing polish needed for a
  downloadable build.
- Gate 5: reduced to Android release-build and APK smoke testing.
- Gate 6: cancelled and replaced by GitHub release verification.

## Consequences

The APK is not a Play Store or App Store candidate. Future store distribution
requires a new ADR or an amendment that reopens the cancelled gates.
